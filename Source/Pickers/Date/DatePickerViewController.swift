import UIKit

extension UIAlertController {
    
    /// Add a date picker
    ///
    /// - Parameters:
    ///   - mode: date picker mode
    ///   - date: selected date of date picker
    ///   - minimumDate: minimum date of date picker
    ///   - maximumDate: maximum date of date picker
    ///   - action: an action for datePicker value change
    
    public func addDatePicker(mode: UIDatePickerMode, date: Date?, minimumDate: Date? = nil, maximumDate: Date? = nil, action: DatePickerViewController.Action?) {
        let datePicker = DatePickerViewController(mode: mode, date: date, minimumDate: minimumDate, maximumDate: maximumDate, action: action)
        set(vc: datePicker, height: 217)
    }

    public func addCountdownPicker(countDownDuration: TimeInterval? = nil, minuteInterval: Int? = nil, action: DatePickerViewController.CountdownAction?) {
        let datePicker = DatePickerViewController(countDownDuration: countDownDuration, minuteInterval: minuteInterval, action: action)
        set(vc: datePicker, height: 217)
    }
}

final public class DatePickerViewController: UIViewController {
    
    public typealias Action = (Date) -> Void
    public typealias CountdownAction = (TimeInterval) -> Void
    
    fileprivate var action: Action?
    fileprivate var countdownAction: CountdownAction?

    fileprivate var _datePicker = UIDatePicker()
    fileprivate var datePicker: UIDatePicker {
        return _datePicker
    }

    required public init(countDownDuration: TimeInterval? = nil, minuteInterval: Int? = nil, action: CountdownAction?) {
        super.init(nibName: nil, bundle: nil)
        let seconds = Int(countDownDuration ?? 0.0)

        datePicker.datePickerMode = .countDownTimer
        datePicker.addTarget(self, action: #selector(DatePickerViewController.actionForCountdownPicker), for: .valueChanged)
        let calendar = Calendar(identifier: .gregorian)
        let date = DateComponents(calendar: calendar, hour: Int(seconds / 3600), minute: Int((seconds % 3600) / 60)).date!
        datePicker.setDate(date, animated: true)
        //datePicker.countDownDuration = countDownDuration ?? 0.0
        datePicker.minuteInterval = minuteInterval ?? 1
        self.countdownAction = action
    }

    required public init(mode: UIDatePickerMode, date: Date? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil, action: Action?) {
        super.init(nibName: nil, bundle: nil)
        datePicker.datePickerMode = mode
        datePicker.addTarget(self, action: #selector(DatePickerViewController.actionForDatePicker), for: .valueChanged)
        datePicker.date = date ?? Date()
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = maximumDate
        self.action = action
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log("has deinitialized")
    }
    
    override public func loadView() {
        view = datePicker
    }

    @objc func actionForCountdownPicker() {
        countdownAction?(datePicker.countDownDuration)
    }

    @objc func actionForDatePicker() {
        action?(datePicker.date)
    }
    
    public func setDate(_ date: Date) {
        datePicker.setDate(date, animated: true)
    }
}
