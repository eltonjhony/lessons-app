//
//  ResponseMockData.swift
//  LessonsAppTests
//
//  Created by Elton Jhony on 06/03/23.
//

import Foundation

let lessonsData: Data =  #"""
    {
        "lessons": [
            {
                "id": 950,
                "name": "The Key To Success In iPhone Photography",
                "description": "What\u2019s the secret to taking truly incredible iPhone photos? Learning how to use your iPhone camera is very important, but there\u2019s something even more fundamental to iPhone photography that will help you take the photos of your dreams! Watch this video to learn some unique photography techniques and to discover your own key to success in iPhone photography!",
                "thumbnail": "https:\/\/embed-ssl.wistia.com\/deliveries\/b57817b5b05c3e3129b7071eee83ecb7.jpg?image_crop_resized=1000x560",
                "video_url": "https:\/\/embed-ssl.wistia.com\/deliveries\/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88\/accudvh5jy.mp4"
            }
        ]
    }
"""#.data(using: .utf8) ?? Data()
