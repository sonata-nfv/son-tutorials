<?php
    


?>
<html>
<head>
<title>Cat Tube</title>
<style>
body {
    background-color:#eee;
    margin:0;
    font-family:sans-serif;
}
#topbar {
    background-color:#fff;
    border-bottom:solid 1px #e0e0e0;
    top:0;
    position:fixed;
    width:100%;
    height:50px;
    z-index:10;
    /*vertical-align:middle;*/
    padding-top:0px;
    padding-bottom:0px;
    padding-left:40px;
    padding-right:30px;
    line-height:50px;
}
#rest {
    margin-left:auto;
    margin-right:auto;
    margin-top:60px; 
    max-width:1065px;
    position:relative;
}
#mirrorbox {
    background-color:#fff;
    outline:solid 1px #e0e0e0;
    padding:15px;
    padding-top:15px;
    padding-bottom:15px;
    margin-bottom:10px;
    margin-right:350px;
    font-size:90%;
}

#mirrorbox span{
    font-size:150%;
    color:#06a529;
    font-weight:bold;
}
#indexbox {
    top:0;
    background-color:#fff;
    outline:solid 1px #e0e0e0;
    min-height:200px;
    padding:15px;
    margin-right:350px;
    margin-bottom:100px;
}
#videobox {
    width:100%;
    height:360px;
    background-color:#000;
    margin-bottom:10px;
}
#videobox #video {
    width: 100%;
    height: 100%;
}
#detailsbox {
    background-color:#fff;
    outline:solid 1px #e0e0e0;
    width:610px;
    height:145px;
    padding:15px;
    padding-top:15px;
    padding-bottom:15px
    
}

#videotextbox {
    background-color:#fff;
    outline:solid 1px #e0e0e0;
    width:610px;
    padding:15px;
    padding-top:15px;
    padding-bottom:15px;
    margin-top:10px;
}

#menubtn {
    vertical-align:middle;
    color:#ccc;
}
#menubtn:hover {
    color:#666;
    cursor:pointer;
}
#logo {
    display:inline-block;
    width:73px;
    height:30px;
    background:url(cattube.png);
    margin-left:15px;
    vertical-align:middle;
}
#logo:hover {
    width:84px;
    background:url(cattubec.png);
}
#searchbar {
    outline:solid 1px #e0e0e0;
    border:none;
    color:#ccc;
    height:28px;
    width:600px;
    font-size:90%;
    margin-left:100px;
}
#searchbtn {
    display:inline-block;
    outline:solid 1px #e0e0e0;
    background-color:#f8f8f8;
    height:23px;
    width:60px;
    cursor:pointer;
    vertical-align:middle;
    margin-left:-5px;
    text-align:center;
    padding-top:5px;
    color:#bbb;
}
#uploadbtn {
    display:inline-block;
    height:23px;
    line-height:50px;
    float:right;
    vertical-align:middle;
    margin-right:25px;
    color:#ccc;
    cursor:pointer;
}
#uploadbtn:hover {
    color:#666;
}
#signinbtn {
    display:inline-block;
    height:28px;
    width:60px;
    background-color:#06a529;
    color:#fff;
    font-size:67%;
    vertical-align:middle;
    text-align:center;
    float:right;
    margin-right:80px;
    margin-top:12px;
    line-height:28px;
    cursor:pointer;
}
#trending span{
    background-color:#eee;
    font-size:70%;
}
#videotitle {
    font-size:130%;
}
#videoauthor {
    margin-top:10px;
    height:60px;
}
#videoauthor img{
    width:48px;
    height:48px;
    background-color:#eee;
    float:left;
}
#videoauthor div {
    margin-left:10px;
    float:left;
}
#channelname {
    font-size:75%;
    display:block;
}
#subscribebtn {
    margin-top:5px;
    display:block;
    background-color:#06a529;
    color:#fff;
    vertical-align:middle;
    height:18px;
    line-height:18px;
    padding:3px;
    padding-left:5px;
    width:90px;
    cursor:pointer;
}
#subscribebtn:hover {
    background-color:#069519;
}
#subscribelogo {
    font-size:100%;
    display:inline-block;
}
#subscribetext {
    font-size:80%;
    display:inline-block;
    margin-bottom:2px;
}
#views {
    float:right;
    height:90px;
    line-height:90px;
    color:#777;
}
#detailsbox hr{
    width:100%;
    color:#ddd;
    border:solid 0.5px #eee;
    margin:0;
    margin-bottom:10px;
}
#additionalbuttons > span{
    color:#aaa;
    margin-right:10px;
    font-size:80%;
    vertical-align:middle;
}
#additionalbuttons > span:hover{
    color:#888;
    cursor:pointer;
}
#additionalbuttons > span .fa{
    font-size:150%;
    vertical-align:middle;
    margin-right:5px;
}
#published {
    font-size:70%;
    font-weight:bold;
    color:#666;
    margin-bottom:5px;
}
#videodescription {
    font-size:80%;
}
#videotextbox {
}
#videotextbox hr{
    margin-top:15px;
    border:solid 1px #eee;
}
#videotextbox #showmore{
    text-align:center;
    font-size:60%;
/*    font-weight:bold;*/
    color:#aaa;
    /*font-variant: small-caps;*/
}
#videotextbox #showmore:hover{
    color:#555;
    cursor:pointer;
}
#upnext{
    font-size:85%;
    font-weight:bold;
    color:#444;
    margin-bottom:10px;
}
.listitem{
    width:100%;
    height:160px;
    clear:left;
}
.listitem .imgbox{
    float:left;
    width:246px;
    height:138px;
    background-color:#aaa;
    margin-right:5px;
    position:relative;
}
.listitem .imgbox img{
    width:246px;
    height:138px;
}
.listitem .imgbox span{
    color:white;
    background-color:black;

    position:absolute;
    right:0;
    bottom:0;

    text-align:right;
    vertical-align:bottom;
    padding:2px;
    padding-left:4px;
    padding-right:4px;
    font-size:65%;
}
.listitem .itemtext{
    /*float:left;*/
    margin-left:5px;
}
.listitem .itemtext .itemtitle{
    font-size:100%;
/*    font-weight:bold;*/
    margin-bottom:3px;
}
.listitem .itemtext .itemtitle a{
    text-decoration:none;
/*    color: #444;*/
    color: #06a529;
}
.listitem .itemtext .itemtitle a:hover{
    color: #06a529;
    text-decoration:underline;
}
.listitem .itemtext .itemchannel{
    font-size:65%;
    margin-bottom:3px;
    color:#888;
}
.listitem .itemtext .itemviews{
    font-size:65%;
    color:#888;
}
.listitem .itemtext .itemviews span{
    border:solid 1px #ddd;
    color:#444;
    padding:2px;
    padding-left:4px;
    padding-right:4px;
}
#rightbox hr {
    border:solid 1px #ddd;
}
.listitem .itemtext .itemdesc{
    font-size:80%;
    color:#888;
    margin-top:5px;
}

</style>
<link rel="stylesheet" href="font-awesome.css">
<script>
/*
function (){
    var filename = '<?php  if (isset($requestVideo["filename"])) {echo htmlentities($requestVideo["filename"]);} else {echo "Unknown Filename";} ?>';
    var req = new XMLHttpRequest();
    var num = new Date().getTime();
    req.open('GET', '/'+filename+'?'+num, true);
    req.responseType = 'blob';

    req.onload = function() {
       // Onload is triggered even on 404
       // so we need to check the status code
       if (this.status === 200) {
          var videoBlob = this.response;
          var vid = URL.createObjectURL(videoBlob); // IE10+
          // Video is now downloaded
          // and we can set it as source on the video element
          var video = document.createElement("video");
          video.src = vid;
          video.setAttribute("class","myvideo");
          video.loop = true;
          var body = document.getElementById("player-api");
          body.appendChild(video);
          video.play();
       }
    }
    req.onerror = function() {
       // Error
    }

    req.send();

}
*/
</script>
</head>
<body>
<div id="topbar">
    <span id="menubtn" class="fa fa-bars" aria-hidden="true"></span>
    <a href="."><span id="logo"></span></a>
    <input id="searchbar" type="text" value="Search"></span>
    <span id="searchbtn"><span class="fa fa-search" aria-hidden="true"></span></span>
    <span id="signinbtn">Sign in</span>
    <a href="upload.php"><span id="uploadbtn" class="fa fa-upload" aria-hidden="true"></span></a>
    <span id="mirror"></span>
</div>
<div id="rest">

        


    <div id="indexbox">
        <div id="upnext">
            Trending
        </div>
<?php
$i = 0;
for($i =0; $i<count($videos); $i++) {
    $video = $videos[$i];
?>
        <div class="listitem">
            <div class="imgbox">
                <img src="<?php
if (isset($video["preview"])) {
    echo htmlentities($video["preview"]);
} else {
    echo "cat.jpg";
}
?>"/>
                <span>
<?php
if (isset($video["length"])) {
    echo htmlentities($video["length"]);
} else {
    echo "0:00";
}
?>
                </span>
            </div>
            <div class="itemtext">
                <div class="itemtitle"><a href="<?php
if (isset($video["basename"])) {
    echo '?video='.$video["basename"];
} else {
    echo ".";
}
?>"><?php
if (isset($video["title"])) {
    echo htmlentities($video["title"]);
} else {
    echo "Unknown Title";
}
?></a>
                </div>
                <div class="itemchannel">
<?php
if (isset($video["channel"])) {
    echo htmlentities($video["channel"]);
} else {
    echo "Unknown Channel";
}
?>
                </div>
                <div class="itemviews">
<?php
if (isset($video["views"])) {
    echo htmlentities(number_format($video["views"]));
} else {
    echo "Unknown Views";
}
?>
                     views
                    <span>NEW</span>
                </div>
                <div class="itemdesc">
<?php
if (isset($video["description"])) {
    echo htmlentities($video["description"]);
} else {
    echo "Unknown Description";
}
?>               
                </div>
            </div>
        </div>
<?php
}
?>
    </div>
</div>
</body>
</html>
