# Low-Cost Embedded Environmental Monitoring & Causal Digital Filtering

A master's-level practical engineering project demonstrating real-time data acquisition, edge computing, and causal digital signal processing using an Arduino Uno R4 Minima and MATLAB.

---

## 📂 Project Structure
```text
├── arduino/
│   └── sensor_filter.ino         # Edge firmware for data acquisition & real-time MA
├── matlab/
│   └── analyze_environment.m     # Offline analysis script (MA vs. EMA comparison)
├── data/
│   └── environment_data.csv      # Sample logged sensor dataset
└── docs/
    └── images/
        └── filter_comparison.png # MATLAB evaluation plot

System Architecture

Sensing Layer: DHT11 temperature and humidity sensor connected to an Arduino Uno R4 Minima.   

Edge Processing: The microcontroller runs a non-blocking loop ($T=2s sampling rate) utilizing a circular buffer to compute a real-time 5-sample causal Moving Average (MA).   

Communication: Structured CSV strings stream over a high-speed UART connection ($115200 baud).   

Post-Processing & Evaluation: MATLAB imports the logged data to contrast causal Moving Averages across multiple window sizes ($N = 3, 5, 10$) and an Exponential Moving Average (EMA). 

Results & Filter Performance

Digital filtering effectively suppresses high-frequency quantization noise inherent in low-cost sensors, but introduces a predictable group delay.

Quantitative Noise Reduction (Standard Deviation Metrics)

Raw Signal Standard Deviation: Baseline variance
MA (N=3): Moderate smoothing
MA (N=5): Balanced noise reduction
MA (N=10): High smoothing, increased response lag
EMA (alpha = 0.25): Responsive exponential smoothing\


How to Run

Firmware: Open arduino/sensor_filter.ino in the Arduino IDE, select the Arduino Uno R4 Minima board, and flash it.   

Data Logging: Capture the serial CSV stream into environment_data.csv[cite: 1, 2].

Analysis: Run matlab/analyze_environment.m inside MATLAB[cite: 1, 2] to generate performance plots and metric logs.