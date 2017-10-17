<?php

function endsWith( $str, $sub ) {
   return ( substr( $str, strlen( $str ) - strlen( $sub ) ) === $sub );
}

$video = null;
if (isset($_GET["video"])) {
    $video = $_GET["video"];
}

$dir_content = scandir(".");
$video_files = array();


foreach( $dir_content as $file ) {
    if (endsWith($file, ".mp4")) {    
        //echo "\r\n".$file;
        array_push($video_files, $file);
    }
    //if (endsWith($file, ".avi")) {    
    //    //echo "\r\n".$file;
    //    array_push($video_files, $file);
    //}
}

$videos = array();
$requestVideo = null;
foreach( $video_files as $vfile) {
    // read yml for each file
    $basename = substr($vfile, 0, strlen($vfile)-4);
    $jsonfile = $basename . ".json";

    // compare filename with requested name
    if (file_exists( $jsonfile )) {
        $jfd = fopen( $jsonfile, "r" );
        $json = null;
        if ($jfd != FALSE) {
            $json = fread($jfd, filesize($jsonfile));
            fclose($jfd);
        }
        $avatar = "avatar_cat.png";
        if (strpos($vfile, "dog") !== FALSE) {
            $avatar = "avatar_dog.png";
        }
        $newVideo = null;
        if ($json == null) {
            $newVideo = array("filename" => $vfile, "title" => "title", "description" => "description", "channel" => "channel", "length" => "13:37", "preview" => "none.jpg", "published" => "Mar 22, 2017", "views" => 123456);
        } else {
            $jsonarray = json_decode($json, true);
            $jsonarray["filename"] = $vfile;
            $newVideo = $jsonarray;
        }
        $newVideo["avatar"] = $avatar;
        $newVideo["basename"] = $basename;
        if ($video !== null && $basename === $video) {
            $requestVideo = $newVideo;
        } else {
            array_push($videos, $newVideo);
        }
    }
}

if ($requestVideo === null) {
    include("tube_index.inc");
} else {
    include("tube_video.inc");
}


?>
