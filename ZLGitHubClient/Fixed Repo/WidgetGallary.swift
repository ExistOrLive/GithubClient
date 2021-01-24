//
//  WidgetGallary.swift
//  Fixed RepoExtension
//
//  Created by 朱猛 on 2021/1/23.
//  Copyright © 2021 ZM. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI

@main
struct WidgetGallary : WidgetBundle {
    @WidgetBundleBuilder
     var body: some Widget {
        TrendingRepoWidget()
        ContributionWidget()
     }
}
