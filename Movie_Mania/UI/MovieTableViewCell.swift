//
//  MovieTableViewCell.swift
//  Movie_Mania
//
//  Created by Tahir Awan on 19/10/2026.
//

import UIKit
import Foundation

final class MovieTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "MovieTableViewCell"
    private var imageLoadTask: URLSessionDataTask?
    
    // MARK: - UI Components
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .secondarySystemBackground
        imageView.tintColor = .tertiaryLabel
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemOrange
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, ratingLabel, overviewLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        return stack
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reuse Handling
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        imageLoadTask = nil
        posterImageView.image = UIImage(systemName: "film")
        titleLabel.text = nil
        ratingLabel.text = nil
        overviewLabel.text = nil
    }
    
    // MARK: - Setup UI & Constraints
    private func setupUI() {
        accessoryType = .disclosureIndicator
        contentView.addSubview(posterImageView)
        contentView.addSubview(textStackView)
    }
    
    private func setupConstraints() {
        // Give the bottom constraint on posterImageView a slightly lower priority (999)
        // to avoid harmless Auto Layout warnings while UITableView calculates row height.
        let posterBottomConstraint = posterImageView.bottomAnchor.constraint(
            lessThanOrEqualTo: contentView.bottomAnchor,
            constant: -12
        )
        posterBottomConstraint.priority = .init(999)
        
        NSLayoutConstraint.activate([
            // Poster Image Constraints (80x120 pt)
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            posterBottomConstraint,
            
            // Text Stack Constraints
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            textStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 14),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            textStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Configuration
    func configure(with movie: Movie) throws {
        titleLabel.text = movie.title
        ratingLabel.text = String(format: "⭐️ %.1f / 10", movie.voteAverage)
        overviewLabel.text = movie.overview.isEmpty ? "No overview available." : movie.overview
        
        // Set default placeholder icon
        posterImageView.image = UIImage(systemName: "film")
        
        // Load poster image asynchronously
        
        print(movie.posterPath!)
        guard let components = URLComponents(string: APPConfig.shared.baseURL_Img + "\(movie.posterPath!)") else{
                
            throw APIError.invalidURL
        }
        
        print(components.url)
        guard let url = components.url else { throw APIError.invalidURL }
            
        let request = URLRequest(url: url)
        
        imageLoadTask = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let self,
                  error == nil,
                  let data,
                  let downloadedImage = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self.posterImageView.image = downloadedImage
            }
        }
        imageLoadTask?.resume()
    }
}
