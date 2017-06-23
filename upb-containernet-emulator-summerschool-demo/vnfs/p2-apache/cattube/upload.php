<?php


$mode = null;
if (isset($_GET["mode"]) && $_GET["mode"] === "upload") {
    $mode = "upload";
}

if ($mode === null) {
    include("tube_upload.inc");
} else {
    // file upload

    if (isset($_FILES["file"]) && isset($_FILES["file"]["name"]) && 
            substr($_FILES["file"]["name"],strlen($_FILES["file"]["name"])-4,strlen($_FILES["file"]["name"])) === ".mp4" && 
            !file_exists( $_FILES["file"]["name"] )) {

        $newname = $_FILES["file"]["name"];
        $basename = substr($newname, 0, strlen($newname)-4);

        move_uploaded_file($_FILES["file"]["tmp_name"], $newname);

        // get duration
        $duration = "1:23";
        $durationstr = shell_exec("ffmpeg -i ".$newname." 2>&1 | grep Duration | cut -d ' ' -f 4");
        if ($durationstr !== null) {
            $durarray = explode(":", substr($durationstr, 0, strlen($durationstr)-5));
            $duration = "";
            if ($durarray[0] != "00") {
                $duration .= $durarray.":";
            }
            $duration .= $durarray[1].":".$durarray[2];
        }

        // create preview image
        shell_exec("ffmpeg -ss 00:00:00 -i ".$newname." -vframes 1 -q:v 2 ".$basename.".jpg");

        $channel = "Cat Flicks Premium";
        if (isset($_POST["channel"]) && strlen($_POST["channel"]) > 0)
            $channel = $_POST["channel"];

        $title = "Cool Video";
        if (isset($_POST["title"]) && strlen($_POST["title"]) > 0)
            $title = $_POST["title"];

        $desc = "Bla Bla Bla";
        if (isset($_POST["desc"]) && strlen($_POST["desc"]) > 0)
            $desc = $_POST["desc"];
    
        $newVideo = array("title" => $title, "description" => $desc, "channel" => $channel, "length" => $duration, "preview" => $basename.".jpg", "published" => date("M t, Y", time()), "views" => rand(1000, 500000));
        
        file_put_contents($basename.".json", json_encode($newVideo));

        header("Location: index.php?video=".$basename);
        die();

    } else {
        header("Location: upload.php");
        die();
    }
}

?>
