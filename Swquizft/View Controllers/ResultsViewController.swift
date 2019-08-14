//
//  ResultsViewController.swift
//  Swquizft
//
//  Created by Michael Redig on 8/13/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

	@IBOutlet private var _navigationItem: UINavigationItem!
	override var navigationItem: UINavigationItem {
		return _navigationItem
	}
	@IBOutlet var tableView: UITableView!

	let quizCoordinator: QuizCoordinator
	let questionController: QuestionController
	let allTimeStatisticsCache: [(category: Question.Category, tracking: CategoryStatistics.CategoryTracking)]
	

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		fatalError("init(nibName etc not implemented)")
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(quizCoordinator: QuizCoordinator) {
		self.quizCoordinator = quizCoordinator
		self.questionController = quizCoordinator.questionController
		self.allTimeStatisticsCache = quizCoordinator.questionController.categoryStatistics.statistics
			.map { ($0.key, $0.value) }
			.sorted { $0.category.rawValue < $1.category.rawValue }
		super.init(nibName: nil, bundle: nil)
		commonInit()
	}

	private func commonInit() {
		let nib = UINib(nibName: "ResultsViewController", bundle: nil)
		nib.instantiate(withOwner: self, options: nil)

		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
	}

	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		quizCoordinator.quitQuiz()
	}
}

extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 0
		default:
			return allTimeStatisticsCache.count
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		if cell.detailTextLabel == nil {
			cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
		}
		switch indexPath.section {
		case 0:
			break
		default:
			let tracker = allTimeStatisticsCache[indexPath.row]
			cell.textLabel?.text = tracker.category.rawValue
			let info = self.info(from: tracker.tracking)
			cell.detailTextLabel?.text = info.string
			switch info.percentage {
			case 0.95...Double.greatestFiniteMagnitude:
				cell.detailTextLabel?.textColor = .green
			case 0.8..<0.95:
				cell.detailTextLabel?.textColor = .yellow
			case 0.7..<0.8:
				cell.detailTextLabel?.textColor = .orange
			default:
				cell.detailTextLabel?.textColor = .red
			}
		}

		return cell
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "This Quiz"
		default:
			return "All Time"
		}
	}

	private func info(from categoryTracking: CategoryStatistics.CategoryTracking) -> (string: String, percentage: Double) {
		guard categoryTracking.presented != 0 else { return ("0/0 (0%)", 0) }
		let percentage = Double(categoryTracking.correct) / Double(categoryTracking.presented)

		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .percent
		numberFormatter.maximumFractionDigits = 1
		guard let percentString = numberFormatter.string(from: percentage as NSNumber) else { return ("fail", 0) }
		let fraction = "\(categoryTracking.correct)/\(categoryTracking.presented) (\(percentString))"

		return (fraction, percentage)
	}
}
