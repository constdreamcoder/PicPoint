//
//  UnderlineSegmentedControl.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/26/24.
//

import UIKit

final class UnderlineSegmentedControl: UISegmentedControl {
    
    private lazy var underlineView: UIView = {
        let width = bounds.size.width / CGFloat(numberOfSegments)
        let height = 4.0
        let xPosition = CGFloat(selectedSegmentIndex * Int(width))
        let yPosition = bounds.size.height - 1.0
        let frame = CGRect(x: xPosition, y: yPosition - 4, width: width, height: height)
        let view = UIView(frame: frame)
        view.backgroundColor = .black
        addSubview(view)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        removeBackgroundAndDivider()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        removeBackgroundAndDivider()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let underlineFinalXPosition = (bounds.width / CGFloat(numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(
            withDuration: 0.1,
            animations: { [weak self] in
                guard let self else { return }
                underlineView.frame.origin.x = underlineFinalXPosition
            }
        )
    }
    
    private func removeBackgroundAndDivider() {
        let image = UIImage()
        setBackgroundImage(image, for: .normal, barMetrics: .default)
        setBackgroundImage(image, for: .selected, barMetrics: .default)
        setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        
        setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
}
