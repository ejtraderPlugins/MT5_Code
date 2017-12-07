<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<script type="text/javascript" src="/static/js/analytics.js" ></script>
<link type="text/css" rel="stylesheet" href="/static/css/banner-styles.css"/>




    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv='Cache-Control' content='no-cache'>
    <meta http-equiv='Pragma' content='no-cache'>    
    <meta http-equiv='Expires' content='-1'>
    <meta name="format-detection" content="telephone=no">
    <link rel="shortcut icon" href="/web/20130529152648im_/http://i.mql5.com/favicon.ico">
    <link href="/web/20130529152648cs_/http://p.mql5.com/styles/styles.dt12f034666b1.css" type="text/css" rel="stylesheet" media="all">
    <title>MQL5: automated forex trading, strategy tester and custom indicators with MetaTrader</title>
    <script type="text/javascript">
        var mqGlobal = {};
        mqGlobal.AddOnLoad = function(callback)
        {
            if(!this._onload)this._onload=[];
            this._onload[this._onload.length]=callback;
        }
        mqGlobal.AddOnReady = function(callback)
        {
            if(!this._onready)this._onready=[];
            this._onready[this._onready.length]=callback;
        }
    </script>
</head>
<body>
<!-- BEGIN WAYBACK TOOLBAR INSERT -->
<script> if (window.archive_analytics) { window.archive_analytics.values['server_name']="wwwb-app19.us.archive.org";}; </script>

<script type="text/javascript" src="/static/js/disclaim-element.js" ></script>
<script type="text/javascript" src="/static/js/graph-calc.js" ></script>
<script type="text/javascript" src="/static/jflot/jquery.min.js" ></script>
<script type="text/javascript">
//<![CDATA[
var firstDate = 820454400000;
var lastDate = 1420070399999;
var wbPrefix = "/web/";
var wbCurrentUrl = "http:\/\/p.mql5.com\/data\/2\/100\/my_first_ea__3.mq5";

var curYear = -1;
var curMonth = -1;
var yearCount = 18;
var firstYear = 1996;
var imgWidth = 475;
var yearImgWidth = 25;
var monthImgWidth = 2;
var trackerVal = "none";
var displayDay = "29";
var displayMonth = "май";
var displayYear = "2013";
var prettyMonths = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

function showTrackers(val) {
	if(val == trackerVal) {
		return;
	}
	if(val == "inline") {
		document.getElementById("displayYearEl").style.color = "#ec008c";
		document.getElementById("displayMonthEl").style.color = "#ec008c";
		document.getElementById("displayDayEl").style.color = "#ec008c";		
	} else {
		document.getElementById("displayYearEl").innerHTML = displayYear;
		document.getElementById("displayYearEl").style.color = "#ff0";
		document.getElementById("displayMonthEl").innerHTML = displayMonth;
		document.getElementById("displayMonthEl").style.color = "#ff0";
		document.getElementById("displayDayEl").innerHTML = displayDay;
		document.getElementById("displayDayEl").style.color = "#ff0";
	}
   document.getElementById("wbMouseTrackYearImg").style.display = val;
   document.getElementById("wbMouseTrackMonthImg").style.display = val;
   trackerVal = val;
}
function getElementX2(obj) {
	var thing = jQuery(obj);
	if((thing == undefined) 
			|| (typeof thing == "undefined") 
			|| (typeof thing.offset == "undefined")) {
		return getElementX(obj);
	}
	return Math.round(thing.offset().left);
}
function trackMouseMove(event,element) {

   var eventX = getEventX(event);
   var elementX = getElementX2(element);
   var xOff = eventX - elementX;
	if(xOff < 0) {
		xOff = 0;
	} else if(xOff > imgWidth) {
		xOff = imgWidth;
	}
   var monthOff = xOff % yearImgWidth;

   var year = Math.floor(xOff / yearImgWidth);
	var yearStart = year * yearImgWidth;
   var monthOfYear = Math.floor(monthOff / monthImgWidth);
   if(monthOfYear > 11) {
       monthOfYear = 11;
   }
   // 1 extra border pixel at the left edge of the year:
   var month = (year * 12) + monthOfYear;
   var day = 1;
	if(monthOff % 2 == 1) {
		day = 15;
	}
	var dateString = 
		zeroPad(year + firstYear) + 
		zeroPad(monthOfYear+1,2) +
		zeroPad(day,2) + "000000";

	var monthString = prettyMonths[monthOfYear];
	document.getElementById("displayYearEl").innerHTML = year + 1996;
	document.getElementById("displayMonthEl").innerHTML = monthString;
	// looks too jarring when it changes..
	//document.getElementById("displayDayEl").innerHTML = zeroPad(day,2);

	var url = wbPrefix + dateString + '/' +  wbCurrentUrl;
	document.getElementById('wm-graph-anchor').href = url;

   //document.getElementById("wmtbURL").value="evX("+eventX+") elX("+elementX+") xO("+xOff+") y("+year+") m("+month+") monthOff("+monthOff+") DS("+dateString+") Moy("+monthOfYear+") ms("+monthString+")";
   if(curYear != year) {
       var yrOff = year * yearImgWidth;
       document.getElementById("wbMouseTrackYearImg").style.left = yrOff + "px";
       curYear = year;
   }
   if(curMonth != month) {
       var mtOff = year + (month * monthImgWidth) + 1;
       document.getElementById("wbMouseTrackMonthImg").style.left = mtOff + "px";
       curMonth = month;
   }
}
//]]>
</script>

<style type="text/css">body{margin-top:0!important;padding-top:0!important;min-width:800px!important;}#wm-ipp a:hover{text-decoration:underline!important;}</style>
<div id="wm-ipp" lang="en" class="__wb_banner_div" style="display:none; position:relative;padding:0 5px;min-height:70px;min-width:800px">


<div id="wm-ipp-inside" class="__wb_banner_div" style="position:fixed;padding:0!important;margin:0!important;width:97%;min-width:780px;border:5px solid #000;border-top:none;background-image:url(/static/images/toolbar/wm_tb_bk_trns.png);text-align:center;-moz-box-shadow:1px 1px 3px #333;-webkit-box-shadow:1px 1px 3px #333;box-shadow:1px 1px 3px #333;font-size:11px!important;font-family:'Lucida Grande','Arial',sans-serif!important;">
   <table style="border-collapse:collapse;margin:0;padding:0;width:100%;"><tbody><tr>
   <td style="padding:10px;vertical-align:top;min-width:110px;">
   <a href="/web/" title="Wayback Machine home page" style="background-color:transparent;border:none;"><img src="/static/images/toolbar/wayback-toolbar-logo.png" alt="Wayback Machine" width="110" height="39" border="0"/></a>
   </td>
   <td style="padding:0!important;text-align:center;vertical-align:top;width:100%;">

       <table style="border-collapse:collapse;margin:0 auto;padding:0;width:570px;"><tbody><tr>
       <td style="padding:3px 0;" colspan="2">
       <form target="_top" method="get" action="/web/form-submit.jsp" name="wmtb" id="wmtb" style="margin:0!important;padding:0!important;"><input type="text" name="url" id="wmtbURL" value="http://p.mql5.com/data/2/100/my_first_ea__3.mq5" style="width:400px;font-size:11px;font-family:'Lucida Grande','Arial',sans-serif;" onfocus="javascript:this.focus();this.select();" /><input type="hidden" name="type" value="replay" /><input type="hidden" name="date" value="20130529152648" /><input type="submit" value="Go" style="font-size:11px;font-family:'Lucida Grande','Arial',sans-serif;margin-left:5px;width: inherit !important" /><span id="wm_tb_options" style="display:block;"></span></form>
       </td>
       <td style="vertical-align:bottom;padding:5px 0 0 0!important;" rowspan="2">
           <table style="border-collapse:collapse;width:110px;color:#99a;font-family:'Helvetica','Lucida Grande','Arial',sans-serif;"><tbody>
			
           <!-- NEXT/PREV MONTH NAV AND MONTH INDICATOR -->
           <tr style="width:110px;height:16px;font-size:10px!important;">
           	<td style="padding-right:9px;font-size:11px!important;font-weight:bold;text-transform:uppercase;text-align:right;white-space:nowrap;overflow:visible;" nowrap="nowrap">
               
		                <a href="/web/20120408130435/http://p.mql5.com/data/2/100/my_first_ea__3.mq5" style="text-decoration:none;color:#33f;font-weight:bold;background-color:transparent;border:none;" title="8 апр 2012"><strong>АПР</strong></a>
		                
               </td>
               <td id="displayMonthEl" style="background:#000;color:#ff0;font-size:11px!important;font-weight:bold;text-transform:uppercase;width:34px;height:15px;padding-top:1px;text-align:center;" title="You are here: 15:26:48 май 29, 2013">МАЙ</td>
				<td style="padding-left:9px;font-size:11px!important;font-weight:bold;text-transform:uppercase;white-space:nowrap;overflow:visible;" nowrap="nowrap">
               
                       июн
                       
               </td>
           </tr>

           <!-- NEXT/PREV CAPTURE NAV AND DAY OF MONTH INDICATOR -->
           <tr>
               <td style="padding-right:9px;white-space:nowrap;overflow:visible;text-align:right!important;vertical-align:middle!important;" nowrap="nowrap">
               
		                <a href="/web/20120408130435/http://p.mql5.com/data/2/100/my_first_ea__3.mq5" title="13:04:35 апр 8, 2012" style="background-color:transparent;border:none;"><img src="/static/images/toolbar/wm_tb_prv_on.png" alt="Previous capture" width="14" height="16" border="0" /></a>
		                
               </td>
               <td id="displayDayEl" style="background:#000;color:#ff0;width:34px;height:24px;padding:2px 0 0 0;text-align:center;font-size:24px;font-weight: bold;" title="You are here: 15:26:48 май 29, 2013">29</td>
				<td style="padding-left:9px;white-space:nowrap;overflow:visible;text-align:left!important;vertical-align:middle!important;" nowrap="nowrap">
               
                       <img src="/static/images/toolbar/wm_tb_nxt_off.png" alt="Next capture" width="14" height="16" border="0"/>
                       
			    </td>
           </tr>

           <!-- NEXT/PREV YEAR NAV AND YEAR INDICATOR -->
           <tr style="width:110px;height:13px;font-size:9px!important;">
				<td style="padding-right:9px;font-size:11px!important;font-weight: bold;text-align:right;white-space:nowrap;overflow:visible;" nowrap="nowrap">
               
		                <a href="/web/20120408130435/http://p.mql5.com/data/2/100/my_first_ea__3.mq5" style="text-decoration:none;color:#33f;font-weight:bold;background-color:transparent;border:none;" title="8 апр 2012"><strong>2012</strong></a>
		                
               </td>
               <td id="displayYearEl" style="background:#000;color:#ff0;font-size:11px!important;font-weight: bold;padding-top:1px;width:34px;height:13px;text-align:center;" title="You are here: 15:26:48 май 29, 2013">2013</td>
				<td style="padding-left:9px;font-size:11px!important;font-weight: bold;white-space:nowrap;overflow:visible;" nowrap="nowrap">
               
                       2014
                       
				</td>
           </tr>
           </tbody></table>
       </td>

       </tr>
       <tr>
       <td style="vertical-align:middle;padding:0!important;">
           <a href="/web/20130529152648*/http://p.mql5.com/data/2/100/my_first_ea__3.mq5" style="color:#33f;font-size:11px;font-weight:bold;background-color:transparent;border:none;" title="See a list of every capture for this URL"><strong>4 captures</strong></a>
           <div class="__wb_banner_div" style="margin:0!important;padding:0!important;color:#666;font-size:9px;padding-top:2px!important;white-space:nowrap;" title="Timespan for captures of this URL">7 авг 11 - 29 май 13</div>
       </td>
       <td style="padding:0!important;">
       <a style="position:relative; white-space:nowrap; width:475px;height:27px;" href="" id="wm-graph-anchor">
       <div class="__wb_banner_div" id="wm-ipp-sparkline" style="position:relative; white-space:nowrap; width:475px;height:27px;background-color:#fff;cursor:pointer;border-right:1px solid #ccc;" title="Explore captures for this URL">
			<img id="sparklineImgId" style="position:absolute; z-index:9012; top:0px; left:0px;"
				onmouseover="showTrackers('inline');" 
				onmouseout="showTrackers('none');"
				onmousemove="trackMouseMove(event,this)"
				alt="sparklines"
				width="475"
				height="27"
				border="0"
				src="/web/jsp/graph.jsp?graphdata=475_27_1996:-1:000000000000_1997:-1:000000000000_1998:-1:000000000000_1999:-1:000000000000_2000:-1:000000000000_2001:-1:000000000000_2002:-1:000000000000_2003:-1:000000000000_2004:-1:000000000000_2005:-1:000000000000_2006:-1:000000000000_2007:-1:000000000000_2008:-1:000000000000_2009:-1:000000000000_2010:-1:000000000000_2011:-1:000000010000_2012:-1:100100000000_2013:4:000010000000_2014:-1:000000000000"></img>
			<img id="wbMouseTrackYearImg" 
				style="display:none; position:absolute; z-index:9010;"
				width="25" 
				height="27"
				border="0"
				src="/static/images/toolbar/transp-yellow-pixel.png"></img>
			<img id="wbMouseTrackMonthImg"
				style="display:none; position:absolute; z-index:9011; " 
				width="2"
				height="27" 
				border="0"
				src="/static/images/toolbar/transp-red-pixel.png"></img>
       </div>
		</a>

       </td>
       </tr></tbody></table>
   </td>
   <td style="text-align:right;padding:5px;width:65px;font-size:11px!important;">
       <a href="javascript:;" onclick="document.getElementById('wm-ipp').style.display='none';" style="display:block;padding-right:18px;background:url(/static/images/toolbar/wm_tb_close.png) no-repeat 100% 0;color:#33f;font-family:'Lucida Grande','Arial',sans-serif;margin-bottom:23px;background-color:transparent;border:none;" title="Close the toolbar">Close</a>
       <a href="http://faq.web.archive.org/" style="display:block;padding-right:18px;background:url(/static/images/toolbar/wm_tb_help.png) no-repeat 100% 0;color:#33f;font-family:'Lucida Grande','Arial',sans-serif;background-color:transparent;border:none;" title="Get some help using the Wayback Machine">Help</a>
   </td>
   </tr></tbody></table>

</div>
</div>
<script type="text/javascript">
 var wmDisclaimBanner = document.getElementById("wm-ipp");
 if(wmDisclaimBanner != null) {
   disclaimElement(wmDisclaimBanner);
 }
</script>
<!-- END WAYBACK TOOLBAR INSERT -->

<div class="cover">
    <div class="head">
        <a href="/web/20130529152648/http://www.mql5.com/" title="MQL5 - Language of trade strategies built-in the MetaTrader 5 client terminal">
            <img width="75" height="34" alt="MQL5 - Language of trade strategies built-in the MetaTrader 5 client terminal" src="/web/20130529152648im_/http://i.mql5cdn.com/logo.gif">
        </a>
        <h1>Automated Trading and Strategy Testing</h1>
    </div>
    <div class="profilebox">
        <div class='unauth'><a class="userOptions openIdProvider openIdIco" href="/web/20130529152648/https://login.mql5.com/en/auth_login" style="margin-left: 2px;" title="Please sign in. OpenID supported">Login</a>|<a class="userOptions" href="/web/20130529152648/https://login.mql5.com/en/auth_register" title="Please register">Registration</a>&nbsp;<strong>en</strong> | <a href='/web/20130529152648/http://p.mql5.com/ru'>ru</a></div><form onsubmit='document.location.assign(("http://www.mql5.com/en/search") + ($("keyword").value.length>0?("#!keyword="+encodeURIComponent($("keyword").value)):""));return false;' id='main_search_form' action='/web/20130529152648/http://www.mql5.com/en/search' method='post'><div class='inputWrapper'><input Title="Enter search text" id="keyword" name="keyword" type="text" value="" /><input type='submit' value='' style="padding: 0;"></div></form>
    </div>
    <div class="menu"><ul><li><i>&nbsp;</i><a href='/web/20130529152648/http://www.mql5.com/en/wall' name='Wall'>Wall</a></li>
            <li><i>&nbsp;</i><a href='/web/20130529152648/http://www.mql5.com/en/docs' name='Docs'>Docs</a></li>
            <li><i>&nbsp;</i><a href='/web/20130529152648/http://www.mql5.com/en/code' name='Code Base'>Code Base</a></li>
            <li><i>&nbsp;</i><a href='/web/20130529152648/http://www.mql5.com/en/articles' name='Articles'>Articles</a></li>
            <li><i>&nbsp;</i><a href='/web/20130529152648/http://championship.mql5.com/2012/en' name='Championship'>Championship</a></li>
            <li><i>&nbsp;</i><a href='/web/20130529152648/http://www.mql5.com/en/job' name='Jobs'>Jobs</a></li>
            <li><i>&nbsp;</i><a href='/web/20130529152648/http://www.mql5.com/en/market' name='Market'>Market</a></li>
            <li><i>&nbsp;</i><a href='/web/20130529152648/http://www.mql5.com/en/signals' name='Signals'>Signals</a></li>
            <li><i>&nbsp;</i><a href='/web/20130529152648/http://www.mql5.com/en/forum' name='Forum'>Forum</a></li>
            <li class="wrap">&nbsp;</li></ul></div>
    <div class='top_container'>
		<span class="content random">
			<a class="singleline" target="_blank" href="/web/20130529152648/http://www.mql5.com/en/charts/335660/eurcad-d1-alpari-uk-ltd"><span class="random_ico screenshot" style="background-image:url('/web/20130529152648im_/http://charts.mql5cdn.com/1/668/eurcad-d1-alpari-uk-ltd-preview.png');background-position:center center;"></span></a>
			<span class="random_content">Screenshot<br><a class="singleline" target="_blank" href="/web/20130529152648/http://www.mql5.com/en/charts/335660/eurcad-d1-alpari-uk-ltd">EURCAD, D1</a><br>Demo			</span>
		</span>
		<span class="content random">
			<span class="random_ico signal"></span>
			<span class="random_content">
				Subscribe to signal<br><a class="singleline" target="_blank" href="/web/20130529152648/http://www.mql5.com/en/signals/2687">FullPips Pro light</a><br>
				<span class="state"><span title="Growth">56.55%</span>, <span title="Equity">0.00 CHF</span></span>
			</span>
		</span>
		<span class="content random">
			<span class="random_ico product">
				<span class="mask"><img src="/web/20130529152648im_/http://i.mql5cdn.com/market/Market_frame_60.png" width="44" title="Super G" height="44" alt="Super G"></span><img style="display:inline-block;overflow:hidden;" src="/web/20130529152648im_/http://c.mql5cdn.com/31/2/SuperG_60x60.png" width="40" height="40" title="Super G" alt="Super G">
			</span>
			<span class="random_content">Try product<br><a class="singleline" target="_blank" href="/web/20130529152648/http://www.mql5.com/en/market/product/311" title="Super G">Super G</a><br>Author: <a target="_blank" href="/web/20130529152648/https://login.mql5.com/en/users/achidayat">achidayat</a></span>
		</span>
		<span class="content random">
			<img width="40" height="40" class="random_ico" src="/web/20130529152648im_/http://c.mql5cdn.com/2/595/vps_avatar__1.png" alt="Forex VPS by Fozzy Inc.">
			<span class="random_content"><a target="_blank" href="/web/20130529152648/http://www.mql5.com/en/articles/595" title="Forex VPS by Fozzy Inc.">Forex VPS by Fozzy Inc.</a></span>
		</span>
		<span class="content random">
			<img width="40" height="40" class="random_ico" src="/web/20130529152648im_/http://i.mql5cdn.com/code/indicator.png" alt="iMACD±ATR">
			<span class="random_content">Indicator<br><a class="singleline" target="_blank" href="/web/20130529152648/http://www.mql5.com/en/code/1019" title="iMACD&#177;ATR">iMACD&#177;ATR</a><br>Author: <a target="_blank" href="/web/20130529152648/https://login.mql5.com/en/users/GODZILLA">GODZILLA</a></span>
		</span>
	</div>
        
    <div class="body">
        <div class="top-band">
    <h1>404</h1>
</div>
<div class="pageHeaderLine"></div>
    <div style="height: 250px; padding: 80px 0 0 0;">
        <div style="text-align: right; float: left; width: 400px; padding-right: 50px;">
            <img src="/web/20130529152648im_/http://i.mql5.com/nofound.png" alt="404" title="404" width="149" height="150">
        </div>
        <div style="text-align: left; float: left;">
            <h1 style="margin: 0 0 30px 0; font-size: 40px;">
                404</h1>            
            <p><strong>Page not found</strong></p>
            <p>Check the URL and try again</p>
        </div>
    </div>

    </div>

    <div class="footer">
    <div><a href="/web/20130529152648/http://www.mql5.com/en/docs">MQL5 Strategy Language</a> |
         <a href="/web/20130529152648/http://www.mql5.com/en/code">Source Code Library</a> |
         <a href="/web/20130529152648/http://cloud.mql5.com/en/">MQL5 Cloud Network</a> |
         <a href="/web/20130529152648/http://www.mql5.com/en/articles/100">How to Write an Expert Advisor or an Indicator</a> |
         <a href="/web/20130529152648/http://www.mql5.com/en/job">Order Development of Expert Advisor</a>
    </div>
    <div><a href="/web/20130529152648/http://files.metaquotes.net/metaquotes.software.corp/mt5/mt5setup.exe">Download MetaTrader 5</a> |
         <a href="/web/20130529152648/http://www.metatrader5.com/en">MetaTrader 5 Trade Platform</a> |
         <a href="/web/20130529152648/http://www.metaquotes.net/en/metatrader5">MetaTrader 5 Tour</a> |
          <a href="/web/20130529152648/http://www.mql5.com/">MQL5.Community</a>
    </div>
    <div><a href="/web/20130529152648/http://www.mql5.com/en/about">About</a> |
         <a href="/web/20130529152648/http://www.mql5.com/en/about/terms">Terms and Conditions</a> |
         <a href="/web/20130529152648/http://www.mql5.com/en/about/privacy">Privacy Policy</a>
    </div>
    <div>Copyright 2000-2013, <a href="/web/20130529152648/http://www.metaquotes.net/en">MetaQuotes Software Corp.</a></div>
    <br>
    </div>
</div>

<script src="/web/20130529152648js_/http://p.mql5.com/js/all.dt12f0237c936.js" type="text/javascript"></script>

<script type="text/javascript">
    mqGlobal.AddOnLoad(function()
        {
            var uniqCookie = new mql5_cookie('mql5.com', '51A63A3D-31CC', '4F266A20');
            uniqCookie.Init();
        });
    
</script>
</body>
</html>




<!--
     FILE ARCHIVED ON 15:26:48 май 29, 2013 AND RETRIEVED FROM THE
     INTERNET ARCHIVE ON 11:53:16 апр 28, 2014.
     JAVASCRIPT APPENDED BY WAYBACK MACHINE, COPYRIGHT INTERNET ARCHIVE.

     ALL OTHER CONTENT MAY ALSO BE PROTECTED BY COPYRIGHT (17 U.S.C.
     SECTION 108(a)(3)).
-->
