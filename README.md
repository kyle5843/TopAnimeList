# TopAnimeList
A simple demo for jikan api

Fetch data 架構 MainPage -> MainPageViewModel -> Repository -> RequestManager -> APIHelper

Repository : 處理資料的本地持久化及 DB 存取 (ToDo)
RequestManager: 管理發出的 API request
APIHelper: 實際發出 request

Todo:
Repository should use database(like CoreData) to manage the data from API server.

![image](https://github.com/kyle5843/TopAnimeList/blob/master/IMG_5929.PNG)
