<?php
header('HTTP/1.1 503 Service Temporarily Unavailable');
header('Status: 503 Service Temporarily Unavailable');
header('Retry-After: 300');
?>
<html>
<head>
    <title>200 - OK</title>
    <link href='https://cdn.envoyr.com/docker-http/nginx-errors/errors/css/style.css' rel='stylesheet' type='text/css'>
</head>
<body>
<main>
    <div id='content'>
        <h1>200</h1>
        <h2>OK</h2>
    </div>
</main>
<footer>Powered by <a href="https://www.cdn.gd">CDN.GD</a> - served by <?= gethostname(); ?></footer>
</body>
</html>
