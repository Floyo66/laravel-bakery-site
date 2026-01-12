<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>@yield('title', 'My Laravel App')</title>

    {{-- Tailwind + Vite --}}
    @vite(['resources/css/app.css', 'resources/js/app.js'])

    {{-- Font Awesome --}}
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>

<body class="min-h-screen flex flex-col bg-gradient-to-b from-amber-50 via-orange-50 to-amber-100 font-sans antialiased">

<!-- ── TOP NAV ─────────────────────────────────────── -->
<header class="bg-white/80 backdrop-blur-md shadow-sm sticky top-0 z-50 border-b border-amber-100">
    <div class="container mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <a href="{{ url('/') }}" class="text-2xl font-bold text-amber-800 hover:text-amber-900 transition-colors">
                MyApp
            </a>

            <nav class="flex items-center gap-8">
                <a href="{{ url('/') }}"
                   class="text-amber-800 hover:text-amber-600 font-medium transition-colors">
                    Home
                </a>
                <a href="{{ url('/profile') }}"
                   class="text-amber-800 hover:text-amber-600 font-medium transition-colors">
                    Profile
                </a>
                <a href="{{ url('/crud') }}"
                   class="text-amber-800 hover:text-amber-600 font-medium transition-colors">
                    Crud
                </a>
                <a href="{{ url('/projects') }}"
                   class="text-amber-800 hover:text-amber-600 font-medium transition-colors">
                    Projects
                </a>
            </nav>
        </div>
    </div>
</header>

<!-- ── MAIN CONTENT ────────────────────────────────── -->
<main class="flex-1 container mx-auto px-4 sm:px-6 lg:px-8 py-8 md:py-12">
    @yield('content')
</main>

<!-- ── BOTTOM BAR ──────────────────────────────────── -->
<footer class="bg-white/70 backdrop-blur-sm border-t border-amber-100 mt-auto">
    <div class="container mx-auto px-4 sm:px-6 lg:px-8 py-5">
        <div class="flex justify-center items-center gap-8 text-amber-700">
            <a href="#" class="hover:text-amber-500 hover:scale-110 transition-all text-2xl">
                <i class="fab fa-discord"></i>
            </a>
            <a href="https://www.twitch.tv/grflows" class="hover:text-purple-600 hover:scale-110 transition-all text-2xl">
                <i class="fab fa-twitch"></i>
            </a>
            <a href="https://steamcommunity.com/profiles/76561198280032104/" class="hover:text-gray-800 hover:scale-110 transition-all text-2xl">
                <i class="fab fa-steam"></i>
            </a>
            <a href="https://www.instagram.com/floooo0o/" class="hover:text-pink-600 hover:scale-110 transition-all text-2xl">
                <i class="fab fa-instagram"></i>
            </a>
            <a href="#" class="hover:text-green-600 hover:scale-110 transition-all text-2xl">
                <i class="fab fa-whatsapp"></i>
            </a>
        </div>
    </div>
</footer>

</body>
</html>
