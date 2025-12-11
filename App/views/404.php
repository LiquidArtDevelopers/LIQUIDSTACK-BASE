<!DOCTYPE html>
<html lang="<?=$lang?>">
<head>
    <!-- Global & Variant HEAD -->
    <?php include_once __DIR__.'/../includes/_globalHead.php'?>
</head>
<body>
    <!-- Global BODY -->
    <?php include_once __DIR__.'/../includes/_globalBody.php'?>

    <!-- Global NAV -->
    <?php include_once '../App/includes/_nav.php' ?>

    <div id="smooth-wrapper">
        <div id="smooth-content">
        

        <?php
        // HEADER HERO TIPO 2
        $boton   = controller('moduleButtonType01', 0);
        $moduleH1Type02Button = controller('moduleH1Type01', 0, [
            '{a-button-primary}' => $boton
        ]);
        echo controller('hero01', 0, ['{hero01-content}' => $moduleH1Type02Button]);
        ?>

        <!-- Global FOOTER -->
        <?php include_once '../App/includes/_footer.php' ?>

        </div>
    </div>
      
    
            
</body>
</html>