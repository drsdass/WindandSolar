<!DOCTYPE html>
<html lang="en">
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>USGS Wind Turbine Data Fetcher</title>
    <!-- Load Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        /* Custom font for a cleaner look, similar to your image */
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f3f4f6;
        }
    </style>
</head>
<body class="min-h-screen flex flex-col items-center p-4">

    <!-- Header Section (Mimics the ACTIVAX navigation bar structure) -->
    <header class="w-full max-w-7xl bg-white shadow-lg rounded-xl p-4 md:p-6 mb-8">
        <div class="flex justify-between items-center">
            <h1 class="text-2xl font-bold text-gray-800 tracking-wider">ACTIVAX Mock Project</h1>
            <nav class="hidden md:flex space-x-6 text-sm font-medium">
                <a href="#" class="text-green-600 border-b-2 border-green-600 pb-1">HOME</a>
                <a href="#" class="text-gray-600 hover:text-green-600">ABOUT</a>
                <a href="#" class="text-gray-600 hover:text-green-600">API DATA</a>
                <a href="#" class="text-gray-600 hover:text-green-600">CONTACTS</a>
            </nav>
        </div>
    </header>

    <!-- Main Content Area -->
    <main class="w-full max-w-4xl p-6 bg-white rounded-xl shadow-2xl">
        <h2 class="text-3xl font-extrabold text-gray-900 mb-6 border-b pb-2">
            Wind Turbine Data Integration (USGS)
        </h2>

        <p class="text-gray-600 mb-6">
            This section fetches and displays specific wind turbine data from the USGS Wind Turbine Database API.
        </p>

        <!-- API Data Display Container -->
        <div id="api-data-card" class="p-6 bg-green-50 rounded-lg border-l-4 border-green-500 transition-all duration-300">
            <!-- Loading message or fetched data will appear here -->
            <p id="status-message" class="text-center text-lg text-gray-500">
                Fetching wind turbine data...
            </p>
        </div>
    </main>

    <script type="module">
        // --- Firebase/Authentication Setup (Standard Practice for Real Apps) ---
        const appId = typeof __app_id !== 'undefined' ? __app_id : 'default-app-id';
        const firebaseConfig = typeof __firebase_config !== 'undefined' ? JSON.parse(__firebase_config) : {};
        const initialAuthToken = typeof __initial_auth_token !== 'undefined' ? __initial_auth_token : null;

        import { initializeApp } from "https://www.gstatic.com/firebasejs/11.6.1/firebase-app.js";
        import { getAuth, signInAnonymously, signInWithCustomToken } from "https://www.gstatic.com/firebasejs/11.6.1/firebase-auth.js";
        import { getFirestore } from "https://www.gstatic.com/firebasejs/11.6.1/firebase-firestore.js";

        // Initialize Firebase
        const app = initializeApp(firebaseConfig);
        const db = getFirestore(app);
        const auth = getAuth(app);

        // Sign in anonymously or with custom token
        async function authenticate() {
            try {
                if (initialAuthToken) {
                    await signInWithCustomToken(auth, initialAuthToken);
                } else {
                    await signInAnonymously(auth);
                }
            } catch (error) {
                console.error("Firebase authentication failed:", error);
            }
        }
        authenticate();
        // --- End Firebase Setup ---


        // API Fetching Logic
        // New API URL for USGS Wind Turbine Data (targeting case_id=3038257)
        const API_URL = 'https://energy.usgs.gov/api/uswtdb/v1/turbines?&case_id=eq.3038257';
        const dataCard = document.getElementById('api-data-card');

        /**
         * Fetches data from the specified API endpoint and displays it.
         */
        async function fetchAndDisplayAPI() {
            try {
                dataCard.innerHTML = '<p class="text-center text-lg text-gray-500">Fetching wind turbine data...</p>';

                // 1. Fetch the data from the API source
                const response = await fetch(API_URL);

                // Check if the response was successful
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                // 2. Parse the JSON response (it's expected to be an array of turbine objects)
                const dataArray = await response.json();

                if (dataArray.length === 0) {
                     dataCard.innerHTML = `
                        <div class="text-center text-red-700 bg-red-100 p-4 rounded">
                            No turbine data found for the given ID.
                        </div>
                    `;
                    return;
                }

                // Process the first turbine found (since we queried a single ID)
                const turbine = dataArray[0];

                // 3. Update the DOM with the fetched data
                dataCard.innerHTML = `
                    <p class="text-xs font-semibold uppercase text-green-700 mb-4">
                        API Data Source: USGS Wind Turbine Database (Case ID: ${turbine.case_id})
                    </p>
                    <h3 class="text-2xl font-bold text-gray-800 mb-3">${turbine.t_model || 'Model Unavailable'}</h3>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div class="p-3 bg-white rounded-lg shadow-sm">
                            <p class="text-sm font-semibold text-gray-500">Location:</p>
                            <p class="text-lg text-gray-800">${turbine.p_name || 'Name N/A'}</p>
                            <p class="text-sm text-gray-600">${turbine.t_county || 'County N/A'}, ${turbine.t_state || 'State N/A'}</p>
                        </div>
                        <div class="p-3 bg-white rounded-lg shadow-sm">
                            <p class="text-sm font-semibold text-gray-500">Coordinates:</p>
                            <p class="text-lg text-gray-800">${turbine.xlong.toFixed(4)}° Lon, ${turbine.ylat.toFixed(4)}° Lat</p>
                            <p class="text-sm text-gray-600">Elevation: ${turbine.t_elev || 'N/A'} meters</p>
                        </div>
                        <div class="p-3 bg-white rounded-lg shadow-sm">
                            <p class="text-sm font-semibold text-gray-500">Rotor Diameter:</p>
                            <p class="text-lg text-gray-800">${turbine.t_rd || 'N/A'} meters</p>
                        </div>
                        <div class="p-3 bg-white rounded-lg shadow-sm">
                            <p class="text-sm font-semibold text-gray-500">Rated Capacity:</p>
                            <p class="text-lg text-gray-800">${turbine.t_cap || 'N/A'} kW</p>
                        </div>
                    </div>

                    <div class="mt-4 pt-3 border-t border-green-200">
                        <p class="text-sm text-green-600">Turbine manufacturer: ${turbine.t_manu || 'N/A'}</p>
                    </div>
                `;

            } catch (error) {
                // Handle any errors during fetch or parsing
                console.error("Could not fetch API data:", error);
                dataCard.innerHTML = `
                    <div class="text-center text-red-700 bg-red-100 p-4 rounded border-l-4 border-red-500">
                        Error loading data: ${error.message}. Please check the console for network details.
                    </div>
                `;
            }
        }

        // Call the function when the page loads
        window.onload = fetchAndDisplayAPI;

    </script>
</body>
</html>
