<?php


    
     $connect = mysql_connect("localhost","j02tour_jon","WOZVM875") or 
    die ("failed to connect to database");
   
    mysql_select_db("j02tour_YouCook");

    
    $id = trim(strip_tags(htmlentities($_REQUEST['r'])));
     
    
     if(!isset($id)) { 
          $id = 'ThereIsNoIdSetSoreturnNothing';
     }
     
    

   
    $query='SELECT *   FROM comments WHERE recipeId LIKE "'.$id.'"  ';

    
    
    //echo $query;
  
    
    $results = mysql_query($query) or die ("<xml><OK>NO</OK></xml>");
    echo "<xml><OK>YES</OK>";

    while ($rows = mysql_fetch_assoc($results))
    { 
        echo "<comment>";
        echo "<id>".$rows["id"]."</id>";
        echo "<user>".$rows["userName"]."</user>";
        echo "<date>".$rows["date"]."</date>";
        echo "<body>".$rows["body"]."</body>";
       echo "</comment>";
       }

     mysql_free_result($results);  
   
    echo "</xml>";  
       
?>