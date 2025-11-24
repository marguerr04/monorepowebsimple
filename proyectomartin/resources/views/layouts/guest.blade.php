<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="csrf-token" content="{{ csrf_token() }}">

        <title>{{ config('app.name', 'Laravel') }} - Iniciar Sesión</title>

        <!-- Fonts -->
        <link rel="preconnect" href="https://fonts.bunny.net">
        <link href="https://fonts.bunny.net/css?family=figtree:400,500,600&display=swap" rel="stylesheet" />

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />

        <!-- Tailwind CSS CDN -->
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="font-sans antialiased">
        <div class="min-h-screen flex">
            <!-- Left Side - Login Form -->
            <div class="w-full lg:w-1/2 flex items-center justify-center p-8 bg-gray-50">
                <div class="w-full max-w-md">
                    <!-- Header -->
                    <div class="text-center mb-8">
                        <h1 class="text-4xl font-bold text-emerald-800 mb-2">Sistema Médico</h1>
                        <p class="text-gray-600">Ingresa tus credenciales para continuar</p>
                    </div>

                    <!-- Login Card -->
                    <div class="bg-white rounded-2xl shadow-xl p-8 border-2 border-emerald-700">
                        {{ $slot }}
                    </div>
                </div>
            </div>

            <!-- Right Side - Decorative Background -->
            <div class="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-emerald-800 via-emerald-700 to-emerald-900 items-center justify-center p-12 relative overflow-hidden">
                <!-- Decorative circles -->
                <div class="absolute top-0 right-0 w-96 h-96 bg-emerald-600 rounded-full opacity-20 -mr-48 -mt-48"></div>
                <div class="absolute bottom-0 left-0 w-96 h-96 bg-emerald-900 rounded-full opacity-20 -ml-48 -mb-48"></div>
                
                <div class="text-white text-center z-10">
                    <i class="fas fa-hospital text-9xl mb-8 opacity-80"></i>
                    <h2 class="text-4xl font-bold mb-4">Bienvenido de vuelta</h2>
                    <p class="text-xl text-emerald-100">Gestiona la información médica de manera eficiente y segura</p>
                </div>
            </div>
        </div>
    </body>
</html>
