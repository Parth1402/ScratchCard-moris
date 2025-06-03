//
//  PrivateImageCell.swift
//  Scratch Adventure
//
//  Created by USER on 27/05/25.
//


import VisualEffectView


class PrivateImageCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        return imageView
    }()
    
    var overlayView: UIView = {
        let overlayView = UIView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        overlayView.isHidden = true
        overlayView.layer.cornerRadius = overlayView.frame.width / 2
        overlayView.clipsToBounds = true
        return overlayView
    }()
    

    private let blurEffectView: VisualEffectView = {
           let blurView = VisualEffectView()
           blurView.translatesAutoresizingMaskIntoConstraints = false
           blurView.colorTint = .white
           blurView.colorTintAlpha = 0.3
           blurView.blurRadius = 10
           blurView.scale = 1
           blurView.isHidden = true
           return blurView
       }()
    
    let videoIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_videoIcon"))
       // imageView.tintColor = .b
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()


    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    func setupViews() {
     
//        imageView.layer.cornerRadius = self.frame.width / 2
//        overlayView.layer.cornerRadius = self.frame.width / 2
        
        contentView.addSubview(imageView)
        contentView.addSubview(blurEffectView)
        contentView.addSubview(overlayView)
        contentView.addSubview(videoIcon)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            blurEffectView.topAnchor.constraint(equalTo: imageView.topAnchor),
                blurEffectView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
                blurEffectView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
                blurEffectView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),

            overlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            
            videoIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
              videoIcon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
              videoIcon.widthAnchor.constraint(equalToConstant: 15),
              videoIcon.heightAnchor.constraint(equalToConstant: 15),

        ])
    }

    func configure(item: MediaItem, isSelected: Bool) {
       // imageView.image = UIImage(named: imageName)
        if item.type == "image" {
              imageView.image = UIImage(data: item.data)
          } else if item.type == "video" {
              imageView.image = UIImage.thumbnailFromVideoData(item.data)
          }
        videoIcon.isHidden = (item.type != "video")
        blurEffectView.isHidden = !isSelected
          overlayView.isHidden = true
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        let radius = 2.0

         imageView.layer.cornerRadius = radius
         blurEffectView.layer.cornerRadius = radius
         overlayView.layer.cornerRadius = radius
     }
}