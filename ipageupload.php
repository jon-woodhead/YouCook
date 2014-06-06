<?php
   echo "start"; 


print_r($_FILES);


foreach($_FILES as $file)
{
	echo "** dogfile **";
	echo "\n";
	print_r($file);
	echo "\n";
	echo $file['type'] . "<br>";
   echo $file['name'] . "<br>";
   echo $file['type'] . "<br>";
   echo $file['size'] . "<br>";
   echo $file['error'] . "<br>";
}

echo "testing if file got";
echo $_FILES['userfile']['name'];
echo "end testing if file got";
echo "testing if file got";
echo $_FILES[0];
echo "end testing if file got";

        echo "Received {$_FILES['userfile']['name']} - its size is {$_FILES['userfile']['size']}";
        $uploaddir = '/YC/images/';
        $uploadfile = $uploaddir . basename($_FILES['userfile']['name']);
    echo $uploadfile;
    if (file_exists($_SERVER{'DOCUMENT_ROOT'}.$uploadfile)) echo "It exists";
    else echo "Not exists";
    
    echo $_SERVER{'DOCUMENT_ROOT'};
    
    if( file_exists( $_SERVER{'DOCUMENT_ROOT'} . "/YC/ipageupload.php")) echo "realyy";
    
    
        if (move_uploaded_file($_FILES['userfile']['tmp_name'], $_SERVER{'DOCUMENT_ROOT'}.$uploadfile))
        {
            echo "File is valid, and was successfully uploaded.";
        } 
        else
        {
            echo "Upload failed";
        }

    ?>