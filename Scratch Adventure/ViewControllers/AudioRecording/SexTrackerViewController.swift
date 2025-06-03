//
//  SexTrackerViewController.swift
//  Scratch Adventure
//
//  Created by USER on 27/05/25.
//


import UIKit
import AVFoundation
import Photos

class SexTrackerViewController: UIViewController {
    // MARK: - UI Elements

    var customNavBarView: CustomNavigationBar?
    
    private var captureSession: AVCaptureSession!
    private var videoOutput: AVCaptureMovieFileOutput!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    var recordingTimer: Timer?
    var recordingStartTime: Date?
    
    var audioRecorder: AVAudioRecorder?
    var recordingSession: AVAudioSession!
    var recordingFileURL: URL?

    private var Videotimer: Timer?
      private var VideosecondsElapsed = 0

      private let VideoTimerContainerView: UIView = {
          let view = UIView()
          view.backgroundColor = UIColor.black
          view.layer.cornerRadius = 15
          view.translatesAutoresizingMaskIntoConstraints = false
          return view
      }()

      private let VideodotView: UIView = {
          let view = UIView()
          view.backgroundColor = UIColor.red
          view.layer.cornerRadius = 7
          view.translatesAutoresizingMaskIntoConstraints = false
          return view
      }()

      private let VideotimerLabel: UILabel = {
          let label = UILabel()
          label.textColor = UIColor.white
          label.font = .mymediumSystemFont(ofSize: 16)
          label.text = "0:00"
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
    
    
    var blinkTimer: Timer?
    var isBlinkOn = true
    var isVideoBlinkOn = true
    
    var VideoblinkTimer: Timer?
    
    var isRecordingPaused = false
    var isVideoPaused = false
    var pausedAtTime: Date?
    var totalPausedDuration: TimeInterval = 0



    
    var isSearching = false
    
    var  selectedIndex = 0
    
    var AudioContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    var VideoContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = .clear
        return view
    }()
    
    var HeaderContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let HeaderAudioStatusIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_record_microphone") // Check image name
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    private let HeaderAudioStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Audio recording is On"
        label.font = UIFont.mySystemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let HeaderAudioStatusView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setImage(UIImage(named: "ic_record_cancel")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return cancelButton
    }()

    private let timerCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 120
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let DotView: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = UIFont.myBoldSystemFont(ofSize: 48)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let audioStatusView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let audioStatusIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_record_microphone")?.withRenderingMode(.alwaysOriginal))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let audioStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Audio recording is On"
        label.font = UIFont.mySystemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let mediaOptions: [MediaOption] = [
        MediaOption(title: "None"),
        MediaOption(title: "Audio"),
        MediaOption(title: "Video")
    ]
    
    private lazy var mediaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8

        // Adjust this based on your max cell width
        let estimatedCellWidth: CGFloat = 80
        let sideInset = (UIScreen.main.bounds.width - estimatedCellWidth) / 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(MediaOptionCell.self, forCellWithReuseIdentifier: MediaOptionCell.identifier)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()


    private let leftButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "ic_record_flag")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 32
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let centerButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "ic_record_play")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    private let rightButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "ic_record_remove")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 32
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var hasUserScrolled = false

 //   private var waveLayers: [AnimatedWaveLayer] = []

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setUpBackground()
        setUpNavigationBar()
        setUpHeaderBar()
        startCameraPreview()
        centerButton.isEnabled = false
        setupAudioSession()
        self.view.addSubview(AudioContentContainer)
        self.view.addSubview(VideoContentContainer)
        setupUI()
        NotificationCenter.default.addObserver(self,selector: #selector(AlertUpdated),name: .AudioAlert,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(VideoAlertUpdated),name: .VideoAlert,object: nil)
     //   setupWaveLayers()

        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                AudioContentContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                AudioContentContainer.widthAnchor.constraint(equalToConstant: 460),
                AudioContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                AudioContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                
                VideoContentContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                VideoContentContainer.widthAnchor.constraint(equalToConstant: 460),
                VideoContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                VideoContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                AudioContentContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                AudioContentContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                AudioContentContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                AudioContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                
                VideoContentContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                VideoContentContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                VideoContentContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                VideoContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }
        HeaderContainer.isHidden = true
    }
    
    @objc func AlertUpdated() {
        startRecording()
    }
    
    @objc func VideoAlertUpdated() {
       // startRecording()
        
        startVideoRecording()
    
      
    }
    
    func setupVideoTimerView(){
        
        view.addSubview(VideoTimerContainerView)
                // Add dot and label to container
        VideoTimerContainerView.addSubview(VideodotView)
        VideoTimerContainerView.addSubview(VideotimerLabel)
        
        
        NSLayoutConstraint.activate([
            // Position container in top-left with some padding
            VideoTimerContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            VideoTimerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Fixed height for container
            VideoTimerContainerView.heightAnchor.constraint(equalToConstant: 30),

            // Dot constraints
            VideodotView.leadingAnchor.constraint(equalTo: VideoTimerContainerView.leadingAnchor, constant: 8),
            VideodotView.centerYAnchor.constraint(equalTo: VideoTimerContainerView.centerYAnchor),
            VideodotView.widthAnchor.constraint(equalToConstant: 14),
            VideodotView.heightAnchor.constraint(equalToConstant: 14),

            // Timer label constraints
            VideotimerLabel.leadingAnchor.constraint(equalTo: VideodotView.trailingAnchor, constant: 6),
            VideotimerLabel.trailingAnchor.constraint(equalTo: VideoTimerContainerView.trailingAnchor, constant: -8),
            VideotimerLabel.centerYAnchor.constraint(equalTo: VideoTimerContainerView.centerYAnchor)
        ])
    }
    
    func startCameraPreview() {
        DispatchQueue.global(qos: .userInitiated).async {
            let session = AVCaptureSession()
            session.sessionPreset = .high

            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
                  session.canAddInput(videoInput) else {
                print("Error: Cannot access camera input.")
                return
            }

            session.addInput(videoInput)

            // Create preview layer (must be done on main thread since it updates UI)
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                previewLayer.frame = self.VideoContentContainer.bounds
                self.VideoContentContainer.layer.addSublayer(previewLayer)
                self.previewLayer = previewLayer
            }

            session.startRunning()

            DispatchQueue.main.async {
                self.captureSession = session
            }
        }
    }


    
    func startVideoRecording() {
        centerButton.setImage(UIImage(named:  "ic_record_pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
        centerButton.imageView?.accessibilityIdentifier = "ic_record_pause"
        
        guard captureSession != nil else {
            print("❌ Capture session is nil")
            return
        }

        if videoOutput == nil {
            videoOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
        }
        
    

        if !videoOutput.isRecording {
            let filename = "recording_\(UUID().uuidString).mov"
            guard let fileURL = getFileURL(for: filename) else {
                print("Failed to get file URL")
                return
            }
            videoOutput.startRecording(to: fileURL, recordingDelegate: self)
            print("🎬 Recording started...")
            
            VideoStartTimer()
        }
    }
    
    func stopVideoRecording() {
        if videoOutput?.isRecording == true {
            videoOutput.stopRecording()
            VideoStopTimer()
        }
    }

    private func VideoStartTimer() {
           VideoStopTimer()
           VideosecondsElapsed = 0
           VideotimerLabel.text = "0:00"
           Videotimer = Timer.scheduledTimer(timeInterval: 1.0,
                                        target: self,
                                        selector: #selector(VideoUpdateTime),
                                        userInfo: nil,
                                        repeats: true)
        VideoblinkTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.VideotoggleBlinkDot()
        }
       }

       private func VideoStopTimer() {
           Videotimer?.invalidate()
           Videotimer = nil
           VideosecondsElapsed = 0
           VideotimerLabel.text = "0:00"
           VideoblinkTimer?.invalidate()
           VideoblinkTimer = nil
       }

       @objc private func VideoUpdateTime() {
           VideosecondsElapsed += 1
           let minutes = VideosecondsElapsed / 60
           let seconds = VideosecondsElapsed % 60
           VideotimerLabel.text = String(format: "%d:%02d", minutes, seconds)
       }

    
    func setUpHeaderBar() {
        view.addSubview(HeaderContainer)
        HeaderContainer.addSubview(HeaderAudioStatusView)
        HeaderContainer.addSubview(HeaderAudioStatusIcon)
        HeaderContainer.addSubview(HeaderAudioStatusLabel)
        HeaderContainer.addSubview(cancelButton) // ✅ Add cancelButton

        cancelButton.addTarget(self, action: #selector(stopRecordingUI), for: .touchUpInside)
        
        leftButton.addTarget(self, action: #selector(stopRecordingUI), for: .touchUpInside)

        NSLayoutConstraint.activate([

            
            HeaderContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            HeaderContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            HeaderContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            HeaderContainer.heightAnchor.constraint(equalToConstant: 44),
            
            HeaderAudioStatusView.topAnchor.constraint(equalTo: HeaderContainer.topAnchor),
            HeaderAudioStatusView.centerXAnchor.constraint(equalTo: HeaderContainer.centerXAnchor),
            HeaderAudioStatusView.heightAnchor.constraint(equalToConstant: 40),
            HeaderAudioStatusView.widthAnchor.constraint(greaterThanOrEqualToConstant: 180),

            HeaderAudioStatusIcon.leadingAnchor.constraint(equalTo: HeaderAudioStatusView.leadingAnchor, constant: 12),
            HeaderAudioStatusIcon.centerYAnchor.constraint(equalTo: HeaderAudioStatusView.centerYAnchor),
            HeaderAudioStatusIcon.widthAnchor.constraint(equalToConstant: 22),
            HeaderAudioStatusIcon.heightAnchor.constraint(equalToConstant: 22),

            HeaderAudioStatusLabel.leadingAnchor.constraint(equalTo: HeaderAudioStatusIcon.trailingAnchor, constant: 8),
            HeaderAudioStatusLabel.centerYAnchor.constraint(equalTo: HeaderAudioStatusView.centerYAnchor),
            HeaderAudioStatusLabel.trailingAnchor.constraint(equalTo: HeaderAudioStatusView.trailingAnchor, constant: -12),

            
                        cancelButton.trailingAnchor.constraint(equalTo: HeaderContainer.trailingAnchor, constant: -16),
                        cancelButton.centerYAnchor.constraint(equalTo: HeaderContainer.centerYAnchor),
                        cancelButton.widthAnchor.constraint(equalToConstant: 35),
                          cancelButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = VideoContentContainer.bounds
    }
    
    func setUpNavigationBar() {
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backIcon"),
            titleString: "Sex Tracker",rightImage: UIImage()
        )
        
        guard let customNavBarView = customNavBarView else { return }
        
        customNavBarView.leftButtonTapped = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
        customNavBarView.rightButtonTapped = { [weak self] in
        }
        
        view.addSubview(customNavBarView)
        customNavBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBarView.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    private func setupUI() {
        AudioContentContainer.addSubview(timerCircleView)
        timerCircleView.addSubview(timerLabel)
        timerCircleView.addSubview(DotView)
        AudioContentContainer.addSubview(audioStatusView)
        audioStatusView.addSubview(audioStatusIcon)
        audioStatusView.addSubview(audioStatusLabel)
        view.addSubview(mediaCollectionView)
        view.addSubview(leftButton)
        view.addSubview(centerButton)
        view.addSubview(rightButton)
        
        
        view.addSubview(VideoTimerContainerView)
        VideoTimerContainerView.addSubview(VideodotView)
        VideoTimerContainerView.addSubview(VideotimerLabel)
        
        
        DispatchQueue.main.async {
            self.timerCircleView.layoutIfNeeded()
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.timerCircleView.bounds
            gradientLayer.cornerRadius = self.timerCircleView.layer.cornerRadius
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.colors = [
               
                UIColor(hex: "#AF0E78", alpha: 0.2).cgColor,
                UIColor(hex: "#9A03D0", alpha: 0.2).cgColor
            ]
            self.timerCircleView.layer.insertSublayer(gradientLayer, at: 0)
        }


        timerCircleView.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        audioStatusView.translatesAutoresizingMaskIntoConstraints = false
        audioStatusIcon.translatesAutoresizingMaskIntoConstraints = false
        audioStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        mediaCollectionView.translatesAutoresizingMaskIntoConstraints = false
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        centerButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        VideoTimerContainerView.translatesAutoresizingMaskIntoConstraints = false
        VideodotView.translatesAutoresizingMaskIntoConstraints = false
        VideotimerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        centerButton.addTarget(self, action: #selector(toggleSearch), for: .touchUpInside)

        NSLayoutConstraint.activate([
          

            timerCircleView.topAnchor.constraint(equalTo: AudioContentContainer.topAnchor, constant: 50),
            timerCircleView.centerXAnchor.constraint(equalTo: AudioContentContainer.centerXAnchor),
            timerCircleView.widthAnchor.constraint(equalToConstant: 240),
            timerCircleView.heightAnchor.constraint(equalToConstant: 240),

            timerLabel.centerXAnchor.constraint(equalTo: timerCircleView.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: timerCircleView.centerYAnchor),
            
            DotView.trailingAnchor.constraint(equalTo: timerLabel.leadingAnchor,constant: -16),
            DotView.centerYAnchor.constraint(equalTo: timerCircleView.centerYAnchor),
            DotView.heightAnchor.constraint(equalToConstant: 10),
            DotView.widthAnchor.constraint(equalToConstant: 10),

            audioStatusView.topAnchor.constraint(equalTo: timerCircleView.bottomAnchor, constant: 50),
            audioStatusView.centerXAnchor.constraint(equalTo: AudioContentContainer.centerXAnchor),
            audioStatusView.heightAnchor.constraint(equalToConstant: 32),
            audioStatusView.widthAnchor.constraint(greaterThanOrEqualToConstant: 180),

            audioStatusIcon.leadingAnchor.constraint(equalTo: audioStatusView.leadingAnchor, constant: 12),
            audioStatusIcon.centerYAnchor.constraint(equalTo: audioStatusView.centerYAnchor),
            audioStatusIcon.widthAnchor.constraint(equalToConstant: 18),
            audioStatusIcon.heightAnchor.constraint(equalToConstant: 18),

            audioStatusLabel.leadingAnchor.constraint(equalTo: audioStatusIcon.trailingAnchor, constant: 8),
            audioStatusLabel.centerYAnchor.constraint(equalTo: audioStatusView.centerYAnchor),
            audioStatusLabel.trailingAnchor.constraint(equalTo: audioStatusView.trailingAnchor, constant: -12),

            mediaCollectionView.bottomAnchor.constraint(equalTo: centerButton.topAnchor, constant: -1),
            mediaCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mediaCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mediaCollectionView.heightAnchor.constraint(equalToConstant: 60),

            leftButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            leftButton.trailingAnchor.constraint(equalTo: centerButton.leadingAnchor, constant: -1),
            leftButton.widthAnchor.constraint(equalToConstant: 64),
            leftButton.heightAnchor.constraint(equalToConstant: 64),

            centerButton.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor),
            centerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerButton.widthAnchor.constraint(equalToConstant: 100),
            centerButton.heightAnchor.constraint(equalToConstant: 100),

            rightButton.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor),
            rightButton.leadingAnchor.constraint(equalTo: centerButton.trailingAnchor, constant: 0),
            rightButton.widthAnchor.constraint(equalToConstant: 64),
            rightButton.heightAnchor.constraint(equalToConstant: 64),
            
            
            VideoTimerContainerView.topAnchor.constraint(equalTo: VideoContentContainer.topAnchor, constant: 10),
            VideoTimerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Fixed height for container
            VideoTimerContainerView.heightAnchor.constraint(equalToConstant: 30),

            // Dot constraints
            VideodotView.leadingAnchor.constraint(equalTo: VideoTimerContainerView.leadingAnchor, constant: 8),
            VideodotView.centerYAnchor.constraint(equalTo: VideoTimerContainerView.centerYAnchor),
            VideodotView.widthAnchor.constraint(equalToConstant: 10),
            VideodotView.heightAnchor.constraint(equalToConstant: 10),

            // Timer label constraints
            VideotimerLabel.leadingAnchor.constraint(equalTo: VideodotView.trailingAnchor, constant: 6),
            VideotimerLabel.trailingAnchor.constraint(equalTo: VideoTimerContainerView.trailingAnchor, constant: -8),
            VideotimerLabel.centerYAnchor.constraint(equalTo: VideoTimerContainerView.centerYAnchor)
            
        ])
        
        // Preselect and center item (Audio)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            let indexPath = IndexPath(item: 0, section: 0)
            self.mediaCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            self.collectionView(self.mediaCollectionView, didSelectItemAt: indexPath)
        }
    }
    

    @objc func toggleSearch() {
        isSearching = true
      
        
        if selectedIndex == 1 {
            
            if centerButton.imageView?.accessibilityIdentifier != "ic_record_pause" {
                
                   
                if isRecordingPaused {
                    resumeRecording()
                }else {
                    
                    let popupVC = RecordAudioAlertViewController()
                    popupVC.modalPresentationStyle = .overFullScreen
                    popupVC.isvideo = false
                    popupVC.modalTransitionStyle = .crossDissolve
                    present(popupVC, animated: true, completion: nil)
                   
                }
                } else {
                    isRecordingPaused = true
                   pauseRecording()
                }
            
        }else if selectedIndex == 2 {
            
            if centerButton.imageView?.accessibilityIdentifier != "ic_record_pause" {
                
                   
                if isVideoPaused {
                    stopVideoRecording()
                }else {
                    
                    let popupVC = RecordAudioAlertViewController()
                    popupVC.modalPresentationStyle = .overFullScreen
                    popupVC.isvideo = true
                    popupVC.modalTransitionStyle = .crossDissolve
                    present(popupVC, animated: true, completion: nil)
                   
                }
                } else {
                
                    stopVideoRecording()
                }
            
        }
    }

    func toggleBlinkDot() {
        isBlinkOn.toggle()
        DotView.alpha = isBlinkOn ? 1.0 : 0.0
    }
    
    func VideotoggleBlinkDot() {
        isVideoBlinkOn.toggle()
        VideodotView.alpha = isVideoBlinkOn ? 1.0 : 0.0
    }

    
    // ✅ Helper function to get file URL in the Documents directory
    func getFileURL(for fileName: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        //        let customPath = "Cv"  // Ensure correct subdirectory
        //        let finalDirectory = documentsDirectory.appendingPathComponent(customPath)
        return documentsDirectory.appendingPathComponent(fileName)
    }
  }

// MARK: - CollectionView DataSource
extension SexTrackerViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return mediaOptions.count
      }

      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaOptionCell.identifier, for: indexPath) as? MediaOptionCell else {
              return UICollectionViewCell()
          }
          cell.configure(with: mediaOptions[indexPath.item])
          return cell
      }

      // MARK: - CollectionView Delegate

      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)

          let selectedOption = mediaOptions[indexPath.item]
          switch selectedOption.title {
          case "Audio":
              selectedIndex = 1
              centerButton.isEnabled = true
              audioStatusLabel.text = "Audio recording is On"
              audioStatusView.isHidden = false
              AudioContentContainer.isHidden = false
              VideoContentContainer.isHidden = true
              customNavBarView?.rightButton.setImage(nil, for: .normal)
              VideoTimerContainerView.isHidden = true
          case "Video":
              selectedIndex = 2
              centerButton.isEnabled = true
              audioStatusLabel.text = "Video recording is On"
              audioStatusView.isHidden = false
              AudioContentContainer.isHidden = true
              VideoContentContainer.isHidden = false
              VideoTimerContainerView.isHidden = false
              customNavBarView?.rightButton.setImage(UIImage(named: "ic_record_flash"), for: .normal)
          case "None":
              selectedIndex = 0
              centerButton.isEnabled = false
              audioStatusView.isHidden = true
              AudioContentContainer.isHidden = true
              VideoContentContainer.isHidden = true
              VideoTimerContainerView.isHidden = true
              customNavBarView?.rightButton.setImage(nil, for: .normal)
          default:
              break
          }
      }

      // MARK: - CollectionView FlowLayout

      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let title = mediaOptions[indexPath.item].title
          let font = UIFont.systemFont(ofSize: 15, weight: .medium)
          let size = (title as NSString).size(withAttributes: [.font: font])
          return CGSize(width: size.width + 30, height: 40)
      }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = mediaCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let proposedContentOffset = targetContentOffset.pointee
        let collectionViewSize = mediaCollectionView.bounds.size

        // Get the rect of the area that will be visible after scrolling
        let targetRect = CGRect(x: proposedContentOffset.x,
                                y: 0,
                                width: collectionViewSize.width,
                                height: collectionViewSize.height)

        // Get attributes for visible items in that rect
        guard let layoutAttributes = layout.layoutAttributesForElements(in: targetRect) else { return }

        // Center X of the collection view after scrolling
        let horizontalCenter = proposedContentOffset.x + collectionViewSize.width / 2

        // Find the closest attribute to center
        var closestAttribute: UICollectionViewLayoutAttributes?
        var minDistance: CGFloat = .greatestFiniteMagnitude

        for attributes in layoutAttributes {
            let itemCenterX = attributes.center.x
            let distance = abs(itemCenterX - horizontalCenter)
            if distance < minDistance {
                minDistance = distance
                closestAttribute = attributes
            }
        }

        // Adjust target offset to center the closest item
        guard let closest = closestAttribute else { return }
        let targetX = closest.center.x - collectionViewSize.width / 2
        targetContentOffset.pointee = CGPoint(x: targetX, y: proposedContentOffset.y)

        // Trigger didSelectItemAt for that item
        let indexPath = closest.indexPath
        DispatchQueue.main.async {
            self.mediaCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            self.collectionView(self.mediaCollectionView, didSelectItemAt: indexPath)
        }
    }
}

extension SexTrackerViewController {
    
    func setupAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Microphone access granted")
                    } else {
                        print("Microphone access denied")
                        // Show alert to user
                    }
                }
            }
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }

    func startRecording() {
        HeaderContainer.isHidden = false
        customNavBarView?.isHidden = true
        centerButton.setImage(UIImage(named:  "ic_record_pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
        centerButton.imageView?.accessibilityIdentifier = "ic_record_pause"
        
        let filename = "recording_\(UUID().uuidString).m4a"
        guard let fileURL = getFileURL(for: filename) else {
            print("Failed to get file URL")
            return
        }
        recordingFileURL = fileURL
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            
            // Update UI
            startRecordingUI()
            
        } catch {
            print("Could not start recording: \(error)")
        }
    }

    func pauseRecording() {
        
        centerButton.setImage(UIImage(named:  "ic_record_play")?.withRenderingMode(.alwaysOriginal), for: .normal)
        centerButton.imageView?.accessibilityIdentifier = "ic_record_play"
        
        recordingTimer?.invalidate()
        blinkTimer?.invalidate()
        pausedAtTime = Date()
        audioRecorder?.pause()
    }

    func resumeRecording() {
        centerButton.setImage(UIImage(named:  "ic_record_pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
        centerButton.imageView?.accessibilityIdentifier = "ic_record_pause"
        if let pausedAt = pausedAtTime {
            totalPausedDuration += Date().timeIntervalSince(pausedAt)
            pausedAtTime = nil
        }

        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateRecordingTime()
        }

        blinkTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.toggleBlinkDot()
        }

        audioRecorder?.record()
    }
    
    func startRecordingUI() {
        recordingStartTime = Date()
        totalPausedDuration = 0
        timerLabel.text = "00:00"
        timerLabel.isHidden = false
        DotView.isHidden = false

        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateRecordingTime()
        }

        blinkTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.toggleBlinkDot()
        }
    }

    
    func updateRecordingTime() {
        guard let start = recordingStartTime else { return }
        let elapsed = Date().timeIntervalSince(start) - totalPausedDuration
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    
    @objc func stopRecordingUI() {
        recordingTimer?.invalidate()
        blinkTimer?.invalidate()
        recordingTimer = nil
        blinkTimer = nil
        isRecordingPaused = false
        isSearching = false
        totalPausedDuration = 0
        pausedAtTime = nil
        recordingStartTime = nil

        timerLabel.text = "00:00"
        DotView.isHidden = true
        audioRecorder?.stop()
    
        centerButton.setImage(UIImage(named:  "ic_record_play")?.withRenderingMode(.alwaysOriginal), for: .normal)
        centerButton.imageView?.accessibilityIdentifier = "ic_record_play"

        if let fileURL = recordingFileURL {
            print("Recording saved at: \(fileURL)")
        }

        HeaderContainer.isHidden = !isSearching
        customNavBarView?.isHidden = isSearching
    }
}


extension SexTrackerViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        guard error == nil else {
            print("❌ Recording error: \(error!.localizedDescription)")
            return
        }

        // Save to Photos
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
            }) { saved, error in
                print(saved ? "✅ Video saved" : "❌ Save failed: \(error?.localizedDescription ?? "")")
            }
        }
    }
}
