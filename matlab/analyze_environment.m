% analyze_environment.m
% Master's Project Signal Analysis Script

% 1. Load the recorded dataset
T = readtable("environment_data.csv");

% Compute time in seconds from milliseconds
T.time_s = (T.time_ms - T.time_ms(1)) / 1000;

t = T.time_s;             % Time vector in seconds
x = T.temp_C;             % Raw temperature signal
h = T.humidity_pct;       % Raw humidity signal

% 2. Apply offline digital filters for comparison
% Moving Average windows (3, 5, and 10 samples)
x_ma3  = movmean(x, [2 0]);
x_ma5  = movmean(x, [4 0]);
x_ma10 = movmean(x, [9 0]);

% Exponential Moving Average (EMA) filter
alpha = 0.25;
x_ema = zeros(size(x));
x_ema(1) = x(1);
for k = 2:numel(x)
    x_ema(k) = alpha * x(k) + (1 - alpha) * x_ema(k-1);
end

% 3. Plot and evaluate filter performance
figure('Name', 'Digital Filter Comparison - Temperature', 'NumberTitle', 'off');
plot(t, x, ".", "DisplayName", "Raw Sensor Signal", "Color", [0.7 0.7 0.7]);
hold on;
plot(t, x_ma3, "DisplayName", "MA (Window = 3)", "LineWidth", 1.2);
plot(t, x_ma5, "DisplayName", "MA (Window = 5)", "LineWidth", 1.2);
plot(t, x_ma10, "DisplayName", "MA (Window = 10)", "LineWidth", 1.2);
plot(t, x_ema, "DisplayName", "EMA (\alpha = 0.25)", "LineWidth", 1.5);
xlabel("Time (s)");
ylabel("Temperature (°C)");
title("Master's Project: Causal Digital Filter Evaluation on DHT11 Data");
legend("Location", "best");
grid on;

% 4. Quantify noise reduction (Standard Deviation analysis)
fprintf("--- Signal Noise & Filtering Metrics ---\n");
fprintf("Raw Signal Standard Deviation:    %.4f °C\n", std(x));
fprintf("MA (N=3) Standard Deviation:      %.4f °C\n", std(x_ma3));
fprintf("MA (N=5) Standard Deviation:      %.4f °C\n", std(x_ma5));
fprintf("MA (N=10) Standard Deviation:     %.4f °C\n", std(x_ma10));
fprintf("EMA Standard Deviation:           %.4f °C\n", std(x_ema));