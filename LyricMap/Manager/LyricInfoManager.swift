//
//  LyricInfoManager.swift
//  LyricMap
//
//  Created by StephenFang on 2023/6/1.
//

import Foundation
import CoreLocation

class LyricInfoManager {
    
    private static var sharedManager: LyricInfoManager = {
        let manager = LyricInfoManager()
        return manager
    }()
    
    init() {
        visitedList = []
        favoritedList = []
    }
    
    var visitedList:[LyricInfo]
    var favoritedList:[LyricInfo]
    
    static var infos: [LyricInfo] {
        return [
            LyricInfo(songInfo: SongInfo(songName: "彌敦道", albumName: "Go!", albumImageUrl: "https://i.kfs.io/album/global/102905,2v1/fit/500x500.jpg", artistName: "洪卓立"), content: "彌敦道", locationName: "彌敦道", coordinate: CLLocationCoordinate2D(latitude: 22.316200, longitude: 114.170233)),
            LyricInfo(songInfo: SongInfo(songName: "中環", albumName: "阿田", albumImageUrl: "https://i.kfs.io/album/global/5654587,2v1/fit/500x500.jpg", artistName: "側田"), content: "任你為了他追隨 仍停滯到中區", locationName: "中環", coordinate: CLLocationCoordinate2D(latitude: 22.281507, longitude: 114.159111)),
            LyricInfo(songInfo: SongInfo(songName: "皇后大道東", albumName: "羅大佑自選輯", albumImageUrl: "https://i.kfs.io/album/tw/33279,1v1/fit/500x500.jpg", artistName: "羅大佑"), content: "皇后大道東上為何無皇宫", locationName: "皇后大道", coordinate: CLLocationCoordinate2D(latitude: 22.276037, longitude: 114.170211)),
            LyricInfo(songInfo: SongInfo(songName: "芬梨道上", albumName: "Unlimited", albumImageUrl: "https://i.kfs.io/album/global/83770,2v1/fit/500x500.jpg", artistName: "楊千嬅"), content: "這山頂何其矜貴 怎可給停留一世", locationName: "芬梨道上", coordinate: CLLocationCoordinate2D(latitude: 22.270383, longitude: 114.151611)),
            LyricInfo(songInfo: SongInfo(songName: "九龍公園游泳池", albumName: "香港是個大商場", albumImageUrl: "https://i.kfs.io/album/global/147603846,0v1/fit/500x500.jpg", artistName: "my little airport"), content: "我喜歡九龍公園游泳池，那裡我不再執著一些往事", locationName: "九龍公園", coordinate: CLLocationCoordinate2D(latitude: 22.300436, longitude: 114.169721)),
            LyricInfo(songInfo: SongInfo(songName: "睜開眼", albumName: "Easy", albumImageUrl: "https://i.kfs.io/album/global/321619,2v1/fit/500x500.jpg", artistName: "RubberBand"), content: "回望那獅子山還是會牽掛", locationName: "獅子山", coordinate: CLLocationCoordinate2D(latitude: 22.352150, longitude: 114.184813)),
            LyricInfo(songInfo: SongInfo(songName: "流淚行勝利道", albumName: "新天地", albumImageUrl: "https://i.kfs.io/album/global/3966466,0v1/fit/500x500.jpg", artistName: "許志安"), content: "流淚行勝利道，別再做愛情奴", locationName: "勝利道", coordinate: CLLocationCoordinate2D(latitude: 22.319096, longitude: 114.174676)),
            LyricInfo(songInfo: SongInfo(songName: "時代廣場", albumName: "新天地", albumImageUrl: "https://i.kfs.io/album/global/3966466,0v1/fit/500x500.jpg", artistName: "許志安"), content: "誰站在大屏幕之下心碎痛哭，誰又悄悄往大鐘一邊嘆氣不想倒數", locationName: "時代廣場", coordinate: CLLocationCoordinate2D(latitude: 22.278306, longitude: 114.182146)),
            LyricInfo(songInfo: SongInfo(songName: "黃金時代", albumName: "我的快樂時代", albumImageUrl: "https://i.kfs.io/album/global/137522,0v1/fit/500x500.jpg", artistName: "陳奕迅"), content: "黃金廣場內分手，在時代門外再聚", locationName: "黃金廣場", coordinate: CLLocationCoordinate2D(latitude: 22.279951, longitude: 114.184306)),
            LyricInfo(songInfo: SongInfo(songName: "油尖旺金毛玲", albumName: "油尖旺金毛玲", albumImageUrl: "https://i.kfs.io/album/hk/19038407,1v1/fit/500x500.jpg", artistName: "Serrini"), content: "偷偷唱著這曲幻想他聽見，學下吉他中環賣唱太痴纏", locationName: "中環", coordinate: CLLocationCoordinate2D(latitude: 22.281507, longitude: 114.159111)),
            LyricInfo(songInfo: SongInfo(songName: "山旮旯", albumName: "山旮旯", albumImageUrl: "https://i.kfs.io/album/global/55099662,3v1/fit/500x500.jpg", artistName: "馮允謙"), content: "深水灣，淺水灣，獅子山，你以為定會等", locationName: "深水灣", coordinate: CLLocationCoordinate2D(latitude: 22.240259, longitude: 114.182005)),
            LyricInfo(songInfo: SongInfo(songName: "山旮旯", albumName: "山旮旯", albumImageUrl: "https://i.kfs.io/album/global/55099662,3v1/fit/500x500.jpg", artistName: "馮允謙"), content: "深水灣，淺水灣，獅子山，你以為定會等", locationName: "淺水灣", coordinate: CLLocationCoordinate2D(latitude: 22.234720, longitude: 114.193811)),
            LyricInfo(songInfo: SongInfo(songName: "山旮旯", albumName: "山旮旯", albumImageUrl: "https://i.kfs.io/album/global/55099662,3v1/fit/500x500.jpg", artistName: "馮允謙"), content: "深水灣，淺水灣，獅子山，你以為定會等", locationName: "獅子山", coordinate: CLLocationCoordinate2D(latitude: 22.352150, longitude: 114.184813)),
            LyricInfo(songInfo: SongInfo(songName: "眼紅館", albumName: "代表作", albumImageUrl: "https://i.kfs.io/album/global/326858,1v1/fit/500x500.jpg", artistName: "關智斌"), content: "我信你也紅著眼 寂寞便在紅館中一起搜索", locationName: "紅館", coordinate: CLLocationCoordinate2D(latitude: 22.301356, longitude: 114.182056)),
            LyricInfo(songInfo: SongInfo(songName: "山林道", albumName: "山林道", albumImageUrl: "https://i.kfs.io/album/global/13335437,1v1/fit/500x500.jpg", artistName: "謝安琪 (Kay Tse)"), content: "叢林萬里 別攔著我 舊時熱情又急躁 不看地圖", locationName: "山林道", coordinate: CLLocationCoordinate2D(latitude: 22.302711, longitude: 114.172679)),
            LyricInfo(songInfo: SongInfo(songName: "下一站天后", albumName: "人人彈起 精選", albumImageUrl: "https://i.kfs.io/album/global/145081,1v1/fit/500x500.jpg", artistName: "Twins"), content: "再下個車站 到天后 當然最好", locationName: "天后", coordinate: CLLocationCoordinate2D(latitude: 22.282406, longitude: 114.192012)),
            LyricInfo(songInfo: SongInfo(songName: "下一站天后", albumName: "人人彈起 精選", albumImageUrl: "https://i.kfs.io/album/global/145081,1v1/fit/500x500.jpg", artistName: "Twins"), content: "在百德新街的愛侶 面上有種顧盼自豪", locationName: "百德新街", coordinate: CLLocationCoordinate2D(latitude: 22.281172, longitude: 114.185402)),
            LyricInfo(songInfo: SongInfo(songName: "下一站天后", albumName: "人人彈起 精選", albumImageUrl: "https://i.kfs.io/album/global/145081,1v1/fit/500x500.jpg", artistName: "Twins"), content: "站在大丸前 細心看看我的路", locationName: "大丸百货（已結業）", coordinate: CLLocationCoordinate2D(latitude: 22.280651, longitude: 114.185273)),
            LyricInfo(songInfo: SongInfo(songName: "囍帖街", albumName: "Binary", albumImageUrl: "https://i.kfs.io/album/global/136893,0v1/fit/500x500.jpg", artistName: "謝安琪"), content: "就似這一區 曾經稱得上 美滿甲天下", locationName: "囍帖街（利東街）", coordinate: CLLocationCoordinate2D(latitude: 22.275466, longitude: 114.172164)),
            LyricInfo(songInfo: SongInfo(songName: "老派約會之必要", albumName: "老派約會之必要", albumImageUrl: "https://i.kfs.io/album/global/184229120,0v1/fit/500x500.jpg", artistName: "MC 張天賦"), content: "我可以為你 關起手機 純靈魂對話 怎知道霎眼 就談到 赤柱了", locationName: "赤柱", coordinate: CLLocationCoordinate2D(latitude: 22.219408, longitude: 114.212833)),
            LyricInfo(songInfo: SongInfo(songName: "doodoodoo", albumName: "doodoodoo", albumImageUrl: "https://i.kfs.io/album/global/172436336,0v1/fit/500x500.jpg", artistName: "林家謙"), content: "斑馬亦能跑到一片石板街", locationName: "石板街", coordinate: CLLocationCoordinate2D(latitude: 22.282973, longitude: 114.155535)),
            LyricInfo(songInfo: SongInfo(songName: "doodoodoo", albumName: "doodoodoo", albumImageUrl: "https://i.kfs.io/album/global/172436336,0v1/fit/500x500.jpg", artistName: "林家謙"), content: "海馬渡輪在紅隧旁睡午覺 深水堡壘有著瑪利奧駐守", locationName: "紅隧", coordinate: CLLocationCoordinate2D(latitude: 22.302119, longitude: 114.180232)),
            LyricInfo(songInfo: SongInfo(songName: "時代廣場", albumName: "演奏廳 II - CD", albumImageUrl: "https://i.kfs.io/album/global/82318,0v1/fit/500x500.jpg", artistName: "李克勤"), content: "靜望著鬧市的廣場，那銅像很想故鄉。舊日樹木靜聽風向，一轉眼 大廈直立到天上", locationName: "時代廣場", coordinate: CLLocationCoordinate2D(latitude: 22.278306, longitude: 114.182146)),
            LyricInfo(songInfo: SongInfo(songName: "黃昏點唱機", albumName: "黃昏點唱機", albumImageUrl: "https://i.kfs.io/album/global/8594935,0v1/fit/500x500.jpg", artistName: "容祖兒"), content: "陪我坐天星 港灣觀星 喜愛漫遊 維園散步徑", locationName: "維園", coordinate: CLLocationCoordinate2D(latitude: 22.285335, longitude: 114.190622)),
            LyricInfo(songInfo: SongInfo(songName: "黃昏點唱機", albumName: "黃昏點唱機", albumImageUrl: "https://i.kfs.io/album/global/8594935,0v1/fit/500x500.jpg", artistName: "容祖兒"), content: "見證這個時代去到金鐘 迷失在 迷宮陣", locationName: "金鐘", coordinate: CLLocationCoordinate2D(latitude: 22.282393, longitude: 114.167160)),
            LyricInfo(songInfo: SongInfo(songName: "叮叮車", albumName: "Read Me", albumImageUrl: "https://i.kfs.io/album/global/135924,4v1/fit/500x500.jpg", artistName: "薛凱琪"), content: "一卡卡叮叮車載滿了人和人擦過老市區 星街中看見你天天都帶本小說同樣搭上車去", locationName: "星街", coordinate: CLLocationCoordinate2D(latitude: 22.276179, longitude: 114.168258)),
            LyricInfo(songInfo: SongInfo(songName: "我們的電車上 (走過下世紀)", albumName: "生於斯", albumImageUrl: "https://i.kfs.io/album/global/6305530,5v3/fit/500x500.jpg", artistName: "C AllStar"), content: "想 照著沿路地理 過渡每世紀 途經的跑馬地 然後又再飛繼續橫越萬里", locationName: "跑馬地", coordinate: CLLocationCoordinate2D(latitude: 22.272289, longitude: 114.180362)),
            LyricInfo(songInfo: SongInfo(songName: "我們的電車上 (走過下世紀)", albumName: "生於斯", albumImageUrl: "https://i.kfs.io/album/global/6305530,5v3/fit/500x500.jpg", artistName: "C AllStar"), content: "從筲箕灣到尾 陪住我陪住你", locationName: "筲箕灣", coordinate: CLLocationCoordinate2D(latitude: 22.279109, longitude: 114.229064)),
            LyricInfo(songInfo: SongInfo(songName: "我們的電車上 (走過下世紀)", albumName: "生於斯", albumImageUrl: "https://i.kfs.io/album/global/6305530,5v3/fit/500x500.jpg", artistName: "C AllStar"), content: "看 這銅鑼灣璀璨 每天 依然如常出發", locationName: "銅鑼灣", coordinate: CLLocationCoordinate2D(latitude: 22.280226, longitude: 114.183659)),
            LyricInfo(songInfo: SongInfo(songName: "我們的電車上 (走過下世紀)", albumName: "生於斯", albumImageUrl: "https://i.kfs.io/album/global/6305530,5v3/fit/500x500.jpg", artistName: "C AllStar"), content: "左邊看 看紅棉道風格 轉彎 干諾道亦優雅 下個彎 有站 前面尚有 燦爛", locationName: "紅棉道", coordinate: CLLocationCoordinate2D(latitude: 22.279161, longitude: 114.162991)),
            LyricInfo(songInfo: SongInfo(songName: "我們的電車上 (走過下世紀)", albumName: "生於斯", albumImageUrl: "https://i.kfs.io/album/global/6305530,5v3/fit/500x500.jpg", artistName: "C AllStar"), content: "看 到達皇后街嗎 也許 忽然全部清拆", locationName: "皇后街", coordinate: CLLocationCoordinate2D(latitude: 22.287693, longitude: 114.146861)),
            LyricInfo(songInfo: SongInfo(songName: "我們的電車上 (走過下世紀)", albumName: "生於斯", albumImageUrl: "https://i.kfs.io/album/global/6305530,5v3/fit/500x500.jpg", artistName: "C AllStar"), content: "看 我們無暇眨眼 也許 西環餘味不散", locationName: "西環", coordinate: CLLocationCoordinate2D(latitude: 22.286258, longitude: 114.135641)),
            LyricInfo(songInfo: SongInfo(songName: "維多利亞", albumName: "維多利亞", albumImageUrl: "https://i.kfs.io/album/global/228228833,0v1/fit/500x500.jpg", artistName: "王灝兒"), content: "落日鋪滿這一片海 船上 蕩開了寂寞人的盼待", locationName: "維多利亞港", coordinate: CLLocationCoordinate2D(latitude: 22.288180, longitude: 114.167790)),
            LyricInfo(songInfo: SongInfo(songName: "永和號", albumName: "B.C.", albumImageUrl: "https://i.kfs.io/album/global/135622,1v2/fit/500x500.jpg", artistName: "張繼聰"), content: "半斤消逝時光 感情二両 可會有糴購 百載商號歷史 終會有盡頭 （眼眶濕透）", locationName: "永和號（已結業）", coordinate: CLLocationCoordinate2D(latitude: 22.283427, longitude: 114.154070)),
            LyricInfo(songInfo: SongInfo(songName: "偉業街", albumName: "妳幸福嗎", albumImageUrl: "https://i.kfs.io/album/global/88191258,3v1/fit/500x500.jpg", artistName: "胡鴻鈞"), content: "初初理想無限高 當走進大社會 未能換到甜夢 又一次信著會見到彩虹", locationName: "偉業街", coordinate: CLLocationCoordinate2D(latitude: 22.312992, longitude: 114.218317)),
            LyricInfo(songInfo: SongInfo(songName: "牛頭角青年", albumName: "寂寞的星期五", albumImageUrl: "https://i.kfs.io/album/global/147603629,0v1/fit/500x500.jpg", artistName: "my little airport"), content: "牛頭角的日出都看厭 時間不站在你身邊", locationName: "牛頭角", coordinate: CLLocationCoordinate2D(latitude: 22.315542, longitude: 114.218945)),
            LyricInfo(songInfo: SongInfo(songName: "南昌街王子", albumName: "南昌街王子", albumImageUrl: "https://i.kfs.io/album/global/77059141,4v1/fit/500x500.jpg", artistName: "薛凱琪"), content: "你問南昌街乃幸福終極嗎 他在旁 不快樂嗎", locationName: "南昌街", coordinate: CLLocationCoordinate2D(latitude: 22.328815, longitude: 114.163070)),
            LyricInfo(songInfo: SongInfo(songName: "深水埗 (feat. Geniuz F the FUTURE)", albumName: "深水埗 (feat. Geniuz F the FUTURE)", albumImageUrl: "https://i.kfs.io/album/global/135699677,3v1/fit/500x500.jpg", artistName: "Novel Fergus"), content: "唔係小康之家 冇錢睇私家 貧窮線以下 汝州街排鐵打", locationName: "汝州街", coordinate: CLLocationCoordinate2D(latitude: 22.325854,  longitude: 114.166741)),
            LyricInfo(songInfo: SongInfo(songName: "詩歌舞街", albumName: "SABINA之淚", albumImageUrl: "https://i.kfs.io/album/global/147603622,1v1/fit/500x500.jpg", artistName: "my little airport"), content: "那晚看Russian Red大角咀表演 你與我竟會再遇見", locationName: "大角咀", coordinate: CLLocationCoordinate2D(latitude: 22.318364,  longitude: 114.163280)),
            LyricInfo(songInfo: SongInfo(songName: "詩歌舞街", albumName: "SABINA之淚", albumImageUrl: "https://i.kfs.io/album/global/147603622,1v1/fit/500x500.jpg", artistName: "my little airport"), content: "詩歌舞街地上有著光點閃閃 聽你說外地歷險", locationName: "詩歌舞街", coordinate: CLLocationCoordinate2D(latitude: 22.325298,  longitude: 114.163704)),
        ]
    }
    
    static var wanChaiList: [LyricInfo] {
        return [
        LyricInfo(songInfo: SongInfo(songName: "時代廣場", albumName: "演奏廳 II - CD", albumImageUrl: "https://i.kfs.io/album/global/82318,0v1/fit/500x500.jpg", artistName: "李克勤"), content: "靜望著鬧市的廣場，那銅像很想故鄉。舊日樹木靜聽風向，一轉眼 大廈直立到天上", locationName: "時代廣場", coordinate: CLLocationCoordinate2D(latitude: 22.278306, longitude: 114.182146)),
        LyricInfo(songInfo: SongInfo(songName: "黃昏點唱機", albumName: "黃昏點唱機", albumImageUrl: "https://i.kfs.io/album/global/8594935,0v1/fit/500x500.jpg", artistName: "容祖兒"), content: "陪我坐天星 港灣觀星 喜愛漫遊 維園散步徑", locationName: "維園", coordinate: CLLocationCoordinate2D(latitude: 22.285335, longitude: 114.190622)),
        LyricInfo(songInfo: SongInfo(songName: "叮叮車", albumName: "Read Me", albumImageUrl: "https://i.kfs.io/album/global/135924,4v1/fit/500x500.jpg", artistName: "薛凱琪"), content: "一卡卡叮叮車載滿了人和人擦過老市區 星街中看見你天天都帶本小說同樣搭上車去", locationName: "星街", coordinate: CLLocationCoordinate2D(latitude: 22.276179, longitude: 114.168258)),
        LyricInfo(songInfo: SongInfo(songName: "我們的電車上 (走過下世紀)", albumName: "生於斯", albumImageUrl: "https://i.kfs.io/album/global/6305530,5v3/fit/500x500.jpg", artistName: "C AllStar"), content: "想 照著沿路地理 過渡每世紀 途經的跑馬地 然後又再飛繼續橫越萬里", locationName: "跑馬地", coordinate: CLLocationCoordinate2D(latitude: 22.272289, longitude: 114.180362)),
        LyricInfo(songInfo: SongInfo(songName: "我們的電車上 (走過下世紀)", albumName: "生於斯", albumImageUrl: "https://i.kfs.io/album/global/6305530,5v3/fit/500x500.jpg", artistName: "C AllStar"), content: "看 這銅鑼灣璀璨 每天 依然如常出發", locationName: "銅鑼灣", coordinate: CLLocationCoordinate2D(latitude: 22.280226, longitude: 114.183659)),
        LyricInfo(songInfo: SongInfo(songName: "我們的電車上 (走過下世紀)", albumName: "生於斯", albumImageUrl: "https://i.kfs.io/album/global/6305530,5v3/fit/500x500.jpg", artistName: "C AllStar"), content: "左邊看 看紅棉道風格 轉彎 干諾道亦優雅 下個彎 有站 前面尚有 燦爛", locationName: "紅棉道", coordinate: CLLocationCoordinate2D(latitude: 22.279161, longitude: 114.162991)),
        LyricInfo(songInfo: SongInfo(songName: "囍帖街", albumName: "Binary", albumImageUrl: "https://i.kfs.io/album/global/136893,0v1/fit/500x500.jpg", artistName: "謝安琪"), content: "就似這一區 曾經稱得上 美滿甲天下", locationName: "囍帖街（利東街）", coordinate: CLLocationCoordinate2D(latitude: 22.275466, longitude: 114.172164)),
        LyricInfo(songInfo: SongInfo(songName: "時代廣場", albumName: "新天地", albumImageUrl: "https://i.kfs.io/album/global/3966466,0v1/fit/500x500.jpg", artistName: "許志安"), content: "誰站在大屏幕之下心碎痛哭，誰又悄悄往大鐘一邊嘆氣不想倒數", locationName: "時代廣場", coordinate: CLLocationCoordinate2D(latitude: 22.278306, longitude: 114.182146)),
        LyricInfo(songInfo: SongInfo(songName: "黃金時代", albumName: "我的快樂時代", albumImageUrl: "https://i.kfs.io/album/global/137522,0v1/fit/500x500.jpg", artistName: "陳奕迅"), content: "黃金廣場內分手，在時代門外再聚", locationName: "黃金廣場", coordinate: CLLocationCoordinate2D(latitude: 22.279951, longitude: 114.184306)),
        LyricInfo(songInfo: SongInfo(songName: "下一站天后", albumName: "人人彈起 精選", albumImageUrl: "https://i.kfs.io/album/global/145081,1v1/fit/500x500.jpg", artistName: "Twins"), content: "再下個車站 到天后 當然最好", locationName: "天后", coordinate: CLLocationCoordinate2D(latitude: 22.282406, longitude: 114.192012)),
        LyricInfo(songInfo: SongInfo(songName: "下一站天后", albumName: "人人彈起 精選", albumImageUrl: "https://i.kfs.io/album/global/145081,1v1/fit/500x500.jpg", artistName: "Twins"), content: "在百德新街的愛侶 面上有種顧盼自豪", locationName: "百德新街", coordinate: CLLocationCoordinate2D(latitude: 22.281172, longitude: 114.185402)),
        LyricInfo(songInfo: SongInfo(songName: "下一站天后", albumName: "人人彈起 精選", albumImageUrl: "https://i.kfs.io/album/global/145081,1v1/fit/500x500.jpg", artistName: "Twins"), content: "站在大丸前 細心看看我的路", locationName: "大丸百货（已結業）", coordinate: CLLocationCoordinate2D(latitude: 22.280651, longitude: 114.185273))
        ]
    }
    
    static var centralList: [LyricInfo] {
        return [
            LyricInfo(songInfo: SongInfo(songName: "皇后大道東", albumName: "羅大佑自選輯", albumImageUrl: "https://i.kfs.io/album/tw/33279,1v1/fit/500x500.jpg", artistName: "羅大佑"), content: "皇后大道東上為何無皇宫", locationName: "皇后大道", coordinate: CLLocationCoordinate2D(latitude: 22.276037, longitude: 114.170211)),
            LyricInfo(songInfo: SongInfo(songName: "黃昏點唱機", albumName: "黃昏點唱機", albumImageUrl: "https://i.kfs.io/album/global/8594935,0v1/fit/500x500.jpg", artistName: "容祖兒"), content: "見證這個時代去到金鐘 迷失在 迷宮陣", locationName: "金鐘", coordinate: CLLocationCoordinate2D(latitude: 22.282393, longitude: 114.167160)),
            LyricInfo(songInfo: SongInfo(songName: "我們的電車上 (走過下世紀)", albumName: "生於斯", albumImageUrl: "https://i.kfs.io/album/global/6305530,5v3/fit/500x500.jpg", artistName: "C AllStar"), content: "看 到達皇后街嗎 也許 忽然全部清拆", locationName: "皇后街", coordinate: CLLocationCoordinate2D(latitude: 22.287693, longitude: 114.146861)),
            LyricInfo(songInfo: SongInfo(songName: "我們的電車上 (走過下世紀)", albumName: "生於斯", albumImageUrl: "https://i.kfs.io/album/global/6305530,5v3/fit/500x500.jpg", artistName: "C AllStar"), content: "看 我們無暇眨眼 也許 西環餘味不散", locationName: "西環", coordinate: CLLocationCoordinate2D(latitude: 22.286258, longitude: 114.135641)),
            LyricInfo(songInfo: SongInfo(songName: "維多利亞", albumName: "維多利亞", albumImageUrl: "https://i.kfs.io/album/global/228228833,0v1/fit/500x500.jpg", artistName: "王灝兒"), content: "落日鋪滿這一片海 船上 蕩開了寂寞人的盼待", locationName: "維多利亞港", coordinate: CLLocationCoordinate2D(latitude: 22.288180, longitude: 114.167790)),
            LyricInfo(songInfo: SongInfo(songName: "永和號", albumName: "B.C.", albumImageUrl: "https://i.kfs.io/album/global/135622,1v2/fit/500x500.jpg", artistName: "張繼聰"), content: "半斤消逝時光 感情二両 可會有糴購 百載商號歷史 終會有盡頭 （眼眶濕透）", locationName: "永和號（已結業）", coordinate: CLLocationCoordinate2D(latitude: 22.283427, longitude: 114.154070)),
            LyricInfo(songInfo: SongInfo(songName: "中環", albumName: "阿田", albumImageUrl: "https://i.kfs.io/album/global/5654587,2v1/fit/500x500.jpg", artistName: "側田"), content: "任你為了他追隨 仍停滯到中區", locationName: "中環", coordinate: CLLocationCoordinate2D(latitude: 22.281507, longitude: 114.159111)),
            LyricInfo(songInfo: SongInfo(songName: "doodoodoo", albumName: "doodoodoo", albumImageUrl: "https://i.kfs.io/album/global/172436336,0v1/fit/500x500.jpg", artistName: "林家謙"), content: "斑馬亦能跑到一片石板街", locationName: "石板街", coordinate: CLLocationCoordinate2D(latitude: 22.282973, longitude: 114.155535)),
        ]
    }
    
    static var yauTsimMongList:  [LyricInfo] {
        return [
            LyricInfo(songInfo: SongInfo(songName: "九龍公園游泳池", albumName: "香港是個大商場", albumImageUrl: "https://i.kfs.io/album/global/147603846,0v1/fit/500x500.jpg", artistName: "my little airport"), content: "我喜歡九龍公園游泳池，那裡我不再執著一些往事", locationName: "九龍公園", coordinate: CLLocationCoordinate2D(latitude: 22.300436, longitude: 114.169721)),
            LyricInfo(songInfo: SongInfo(songName: "山林道", albumName: "山林道", albumImageUrl: "https://i.kfs.io/album/global/13335437,1v1/fit/500x500.jpg", artistName: "謝安琪 (Kay Tse)"), content: "叢林萬里 別攔著我 舊時熱情又急躁 不看地圖", locationName: "山林道", coordinate: CLLocationCoordinate2D(latitude: 22.302711, longitude: 114.172679)),
            LyricInfo(songInfo: SongInfo(songName: "彌敦道", albumName: "Go!", albumImageUrl: "https://i.kfs.io/album/global/102905,2v1/fit/500x500.jpg", artistName: "洪卓立"), content: "彌敦道", locationName: "彌敦道", coordinate: CLLocationCoordinate2D(latitude: 22.316200, longitude: 114.170233)),
            LyricInfo(songInfo: SongInfo(songName: "油尖旺金毛玲", albumName: "油尖旺金毛玲", albumImageUrl: "https://i.kfs.io/album/hk/19038407,1v1/fit/500x500.jpg", artistName: "Serrini"), content: "偷偷唱著這曲幻想他聽見，學下吉他中環賣唱太痴纏", locationName: "中環", coordinate: CLLocationCoordinate2D(latitude: 22.281507, longitude: 114.159111)),
        ]}
    
    static var shamShuiPoList:  [LyricInfo] {
        return [
            LyricInfo(songInfo: SongInfo(songName: "南昌街王子", albumName: "南昌街王子", albumImageUrl: "https://i.kfs.io/album/global/77059141,4v1/fit/500x500.jpg", artistName: "薛凱琪"), content: "你問南昌街乃幸福終極嗎 他在旁 不快樂嗎", locationName: "南昌街", coordinate: CLLocationCoordinate2D(latitude: 22.328815, longitude: 114.163070)),
            LyricInfo(songInfo: SongInfo(songName: "深水埗 (feat. Geniuz F the FUTURE)", albumName: "深水埗 (feat. Geniuz F the FUTURE)", albumImageUrl: "https://i.kfs.io/album/global/135699677,3v1/fit/500x500.jpg", artistName: "Novel Fergus"), content: "唔係小康之家 冇錢睇私家 貧窮線以下 汝州街排鐵打", locationName: "汝州街", coordinate: CLLocationCoordinate2D(latitude: 22.325854,  longitude: 114.166741)),
            LyricInfo(songInfo: SongInfo(songName: "詩歌舞街", albumName: "SABINA之淚", albumImageUrl: "https://i.kfs.io/album/global/147603622,1v1/fit/500x500.jpg", artistName: "my little airport"), content: "那晚看Russian Red大角咀表演 你與我竟會再遇見", locationName: "大角咀", coordinate: CLLocationCoordinate2D(latitude: 22.318364,  longitude: 114.163280)),
            LyricInfo(songInfo: SongInfo(songName: "詩歌舞街", albumName: "SABINA之淚", albumImageUrl: "https://i.kfs.io/album/global/147603622,1v1/fit/500x500.jpg", artistName: "my little airport"), content: "詩歌舞街地上有著光點閃閃 聽你說外地歷險", locationName: "詩歌舞街", coordinate: CLLocationCoordinate2D(latitude: 22.325298,  longitude: 114.163704)),
        ]}
    
    // MARK: - Accessors

    class func shared() -> LyricInfoManager {
        return sharedManager
    }
}
