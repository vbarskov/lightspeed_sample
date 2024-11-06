//
//  ProductCell.swift
//  lightspeedbarskov
//
//  Created on 05.11.2024.
//

import UIKit


public class ProductCell: UITableViewCell {
    
    static let reuseIdentifier = "ProductCell"
    
    private var hasError: Bool = false {
        didSet {
            isUserInteractionEnabled = hasError
        }
    }
    
    enum Constants {
        static let spacing: CGFloat = 16
        static let imageHeight: CGFloat = 64
    }
    
    public var viewModel: ProductCellVM? {
        didSet {
            if let viewModel = viewModel {
                update(with: viewModel)
            }
        }
    }
    
    private let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let title: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontForContentSizeCategory = true
        return view
    }()
    
    private let descr: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        view.adjustsFontForContentSizeCategory = true
        return view
    }()
    
    private let price: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontForContentSizeCategory = true
        return view
    }()
    
    private let qty: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontForContentSizeCategory = true
        return view
    }()
    
    private let productImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let vStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = Constants.spacing
        view.distribution = .fill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        guard hasError else { return }
        guard let viewModel = viewModel else { return }
        viewModel.imageLoadingTask?.cancel()
        loadImage(viewModel: viewModel)
        hasError.toggle()
    }
    
    required public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initCell()
        setupTapGesture()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        composeSubviews()
        setConstraints()
    }
    
    public func update(with viewModel: ProductCellVM) {
        
        isUserInteractionEnabled = !viewModel.isLoading
        
        title.attributedText = viewModel.title
        descr.attributedText = viewModel.descr
        price.attributedText = viewModel.price
        qty.attributedText = viewModel.qty
        
        backView.with {
            $0.backgroundColor = viewModel.backgroundColor
        }
        
        productImage.image = nil
        
        loadImage(viewModel: viewModel)
        
    }
    
    private func loadImage(viewModel: ProductCellVM) {
        spinner.startAnimating()
        guard let imageLoadingTask = viewModel.imageLoadingTask else { return }
        imageLoadingTask.start()
        if let task = imageLoadingTask.task {
            Task {
                do {
                    if let data = try await task.value {
                        let resizedImage = await Task.detached { () -> UIImage? in
                            guard let image = UIImage(data: data!) else { return nil }
                            return image.imageResized(to: CGSize(width: Constants.imageHeight, height: Constants.imageHeight))
                        }.value
                        await MainActor.run { [weak self] in
                            self?.productImage.image = resizedImage
                            self?.spinner.stopAnimating()
                        }
                    }
                } catch {
                    switch error {
                    case URLError.cancelled:
                        break
                    default:
                        let placeholderImage = UIImage(systemName: "arrow.clockwise")?.withTintColor(.red, renderingMode: .alwaysOriginal)
                        productImage.image = placeholderImage
                        hasError = true
                        await MainActor.run { [weak self] in
                            self?.spinner.stopAnimating()
                        }
                    }
                    
                }
            }
        }
    }
    
    public func composeSubviews() {
        
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(backView)
        
        backView.addSubview(vStack)
        backView.addSubview(productImage)
        productImage.addSubview(spinner)
        
        vStack.addArrangedSubview(title)
        vStack.addArrangedSubview(descr)
        vStack.addArrangedSubview(price)
        vStack.addArrangedSubview(qty)
    }
    
    public func setConstraints() {
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: backView.topAnchor, constant: Constants.spacing),
            productImage.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            productImage.bottomAnchor.constraint(equalTo: vStack.topAnchor, constant: -Constants.spacing),
            productImage.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
            productImage.widthAnchor.constraint(equalToConstant: Constants.imageHeight)
        ])
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: productImage.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: productImage.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: Constants.spacing),
            vStack.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: Constants.spacing),
            vStack.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -Constants.spacing),
            vStack.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -Constants.spacing)
        ])
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        viewModel?.imageLoadingTask?.cancel()
        productImage.image = nil
        spinner.stopAnimating()
    }
}


