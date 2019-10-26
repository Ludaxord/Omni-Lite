//
//  Omni.swift
//  Omni Lite
//
//  Created by Konrad Uciechowski on 11/04/2019.
//  Copyright © 2019 Homeflix. All rights reserved.
//

import Foundation
import SwiftyJSON

class Omni: API {
    
    override init() {
        super.init()
        print("\(String(describing: self)) injected")
    }
        
    public static let instance = Omni()
    
    func httpGetArticlesByQuery(query: String, articleCompletion: @escaping (Array<Article>?, String?) -> ()) {
        var params: Dictionary<String, String> = Dictionary()
        params[Statics.queryKey] = query
        getAsync(type: 0, params: params) { json, error in
            if json != nil {
                var articlesList: Array<Article> = Array()
                let articles = json![Statics.articlesKey]
                if articles.exists() {
                    for (_, article) in articles {
                        var articleObject = Article()
                        
                        articleObject.articleId = article[Statics.articlesIdKey].string
                        
                        let title = article[Statics.titleKey]
                        if title.exists() {
                            articleObject.titleValue = title[Statics.valueKey].string
                        }
                        
                        let authors = article[Statics.authorsKey]
                        if authors.exists() {
                            var authorsDictionary = Dictionary<String?, String?>()
                            for (_, author) in authors {
                                let authorId = author[Statics.idKey].string
                                let authorTitle = author[Statics.titleKey].string
                                authorsDictionary[authorId] = authorTitle
                            }
                            articleObject.authors = authorsDictionary
                        }
                        
                        let resources = article[Statics.resourcesKey]
                        if resources.exists() {
                            var resourcesArray = Array<JSON>()
                            for (_, resource) in resources {
                                resourcesArray.append(resource)
                            }
                            articleObject.resources = resourcesArray
                        }

                        let tags = article[Statics.tagsKey]
                        if tags.exists() {
                            var tagsArray = Array<JSON>()
                            for (_, tag) in tags {
                                tagsArray.append(tag)
                            }
                            articleObject.tags = tagsArray
                        }
                        
                        articleObject.type = article[Statics.typeKey].string
                        
                        let category = article[Statics.categoryKey]
                        if category.exists() {
                            articleObject.categoryId = category[Statics.categoryIdKey].string
                            articleObject.categoryTitle = category[Statics.titleKey].string
                            articleObject.categorySlug = category[Statics.slugKey].string
                            articleObject.categoryLargeThreshold = category[Statics.largeThresholdKey].string
                            let icon = category[Statics.iconKey]
                            if icon.exists() {
                                articleObject.categoryIconUrl = icon[Statics.imageUrlKey].string
                                let color = icon[Statics.colorKey]
                                if color.exists() {
                                    articleObject.categoryIconColorRed = color[Statics.redKey].string
                                    articleObject.categoryIconColorGreen = color[Statics.greenKey].string
                                    articleObject.categoryIconColorBlue = color[Statics.blueKey].string
                                }
                            }
                            articleObject.categoryDefault = category[Statics.defaultKey].string
                        }
                    
                        let changes = article[Statics.changesKey]
                        if changes.exists() {
                            articleObject.changesPublished = changes[Statics.publishedKey].string
                            articleObject.changesModified = changes[Statics.modifiedKey].string
                        }
                        
                        let story = article[Statics.storyKey]
                        if story.exists() {
                            articleObject.storyType = story[Statics.typeKey].string
                            articleObject.storyTitle = story[Statics.titleKey].string
                            articleObject.storyTopicId = story[Statics.topicIdKey].string
                        }
                        
                        let mainText = article[Statics.mainTextKey]
                        if mainText.exists() {
                            articleObject.mainTextType = mainText[Statics.typeKey].string
                            let paragraphs = mainText[Statics.paragraphsKey]
                            if paragraphs.exists() {
                                var paragraphsDictionary = Dictionary<String?, String?>()
                                for (_, paragraph) in paragraphs {
                                    let text = paragraph[Statics.textKey]
                                    var value: String? = nil
                                    if text.exists() {
                                        value = text[Statics.valueKey].string
                                    }
                                    let blockType = paragraph[Statics.blockTypeKey].string
                                    paragraphsDictionary[value] = blockType
                                }
                                articleObject.mainTextParagraphs = paragraphsDictionary
                            }
                        }
                        
                        let mainResource = article[Statics.mainResourceKey]
                        if mainResource.exists() {
                            articleObject.mainResourceType = mainResource[Statics.typeKey].string
                            articleObject.mainResourceSourceId = mainResource[Statics.sourceIdKey].string
                            let imageAsset = mainResource[Statics.imageAssetKey]
                            if imageAsset.exists() {
                                articleObject.mainResourceImageAssetsId = imageAsset[Statics.idKey].string
                                let size = imageAsset[Statics.sizeKey]
                                if size.exists() {
                                    articleObject.mainResourceImageAssetsSizeWidth = size[Statics.widthKey].string
                                    articleObject.mainResourceImageAssetsSizeHeight = size[Statics.heightKey].string
                                }
                            }
                        }
                        articlesList.append(articleObject)
                    }
                    articleCompletion(articlesList, nil)
                }
            } else if error != nil {
                let errorMessage = "Ups! looks like we've got error: \(error?.localizedDescription)"
                articleCompletion(nil, errorMessage)
            } else {
                let errorMessage = "Ups! unresolved error ocurred"
                articleCompletion(nil, errorMessage)
            }
        }
    }
}
