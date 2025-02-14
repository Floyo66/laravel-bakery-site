<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delicious Bakes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-light bg-white shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">Delicious Bakes</a>
        </div>
    </nav>

    <div class="container text-center mt-5">
        <h1 class="fw-bold">Welcome to Delicious Bakes</h1>
        <p class="lead">We bake the finest cakes for restaurants and coffee places.</p>

        <h2 class="mt-4">Our Cakes</h2>
        <div class="row">
            <div class="col-md-4">
                <img src="{{ asset('images/cake_1.jpg') }}" class="img-fluid rounded shadow-sm" alt="Cake 1">
            </div>
            <div class="col-md-4">
                <img src="{{ asset('images/cake_2.jpg') }}" class="img-fluid rounded shadow-sm" alt="Cake 2">
</body>
</html>
