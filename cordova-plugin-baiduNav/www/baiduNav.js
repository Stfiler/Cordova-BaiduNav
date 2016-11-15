var BaiduMapNav = {
    initAK: function(appkey, success, failure){
        cordova.exec(success,failure,'CDVBaiduNav','initBaiDuNav',[appkey]);

    }
}

module.exports = BaiduMapNav;
