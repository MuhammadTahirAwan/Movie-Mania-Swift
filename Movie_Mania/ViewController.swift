//
//  ViewController.swift
//  Movie_Mania
//
//  Created by Tahir Awan on 14/10/2026.
//

import UIKit

class ViewController: UIViewController {
    
    var movies: [Movie] = []
    var emails: [String] = []
    
    public let network: NetworkServiceProtocol
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 144
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
        return table
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    init(network: NetworkServiceProtocol = NetworkService()) {
        self.network = network
        super.init(nibName: nil, bundle: nil)
    }
    
    // Storyboard unarchiving initializer
    required init?(coder: NSCoder) {
        // Fall back to default service when unarchived from storyboard
        self.network = NetworkService()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupConstraints()
        
        activityIndicator.startAnimating()
        
        //network.request(.movie(), as: [Movie].self) { [weak self] result in
        
        network.request(.movie(), as: MoviesResponse.self) { [weak self] result in
            guard let self else { return }
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let movieReponse):
                self.movies = movieReponse.results
                print(self.movies)
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            if !self.movies.isEmpty {
                //                self.emails = self.movies.compactMap{ $0.email }
            }
            
            //            print(self.emails)
        }
    }
    
    // MARK: - Setup UI & Constraints
    private func setupUI() {
        title = "Top Rated"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = movies[indexPath.row]
        
        
        do {
            try cell.configure(with: movie)
        } catch let error as APIError {
            
            print("API Error: \(error)")
        }catch {
            print("Unexpected error: \(error)")
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedMovie = movies[indexPath.row]
        print("Selected: \(selectedMovie.title ?? "No Title")")
    }
}
