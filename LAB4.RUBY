include Math


fs = 10_000
duration = 1.0
n = (fs * duration).to_i
t = Array.new(n) { |i| i.to_f / fs }


freqs_list = [
  [100],
  [100, 300, 700],
  [100, 300, 700],
]

amps_list = [
  [1],
  [1, 1, 1],
  [3, 2, 1],
]


def generate_signal(freqs, amps, t)
  signal = Array.new(t.length, 0.0)
  freqs.each_with_index do |f, i|
    t.each_with_index do |ti, j|
      signal[j] += amps[i] * cos(2 * PI * f * ti)
    end
  end
  signal
end

def compute_fft(signal)
  n = signal.length
  spectrum = []
  (0...(n/2)).each do |k|
    re = 0.0
    im = 0.0
    n.times do |t|
      angle = 2 * PI * k * t / n
      re += signal[t] * cos(angle)
      im -= signal[t] * sin(angle)
    end
    magnitude = sqrt(re**2 + im**2) / n
    magnitude *= 2 if k != 0  
    spectrum << magnitude
  end
  spectrum
end


def find_peaks(spectrum, fs, threshold = 0.1)
  peaks = []
  n = spectrum.length * 2
  spectrum.each_with_index do |amp, k|
    freq = k * fs.to_f / n
    peaks << freq.round if amp > threshold
  end
  peaks
end


def add_noise(signal, multiplier)
  require 'securerandom'
  rng = Random.new(SecureRandom.random_number(1 << 30))
  signal.map { |x| x + multiplier * gaussian_noise(rng) }
end

def gaussian_noise(rng)

  u1 = rng.rand
  u2 = rng.rand
  Math.sqrt(-2.0 * Math.log(u1)) * Math.cos(2 * Math::PI * u2)
end

puts "\n--- Задача 1: генерация спектров ---"
(0..2).each do |i|
  sig = generate_signal(freqs_list[i], amps_list[i], t)
  puts "\n--- Задание #{i+1} ---"
  puts "f = #{freqs_list[i]}, a = #{amps_list[i]}"
  print "Первые 5 отсчётов: "
  puts sig[0...5].map { |x| format('%.2f', x) }.join(' ')
end

puts "\n--- Задача 2: спектр сигнала ---"
(0..2).each do |i|
  sig = generate_signal(freqs_list[i], amps_list[i], t)
  spectrum = compute_fft(sig)

  puts "\n--- Задание #{i+1} ---"
  puts "Частота(Гц)\tАмплитуда"
  (0...(spectrum.length / 4)).each do |k|
    freq = k * fs.to_f / n
    puts format("%.1f\t%.4f", freq, spectrum[k])
  end

  peaks = find_peaks(spectrum, fs)
  puts "\nЗадание #{i+1}: основные частоты #{peaks.join(', ')} Гц"
  puts "Сжатие данных: #{n} → #{peaks.length * 2} (коэффициент #{(n.to_f / (peaks.length * 2)).round(1)}:1)"
end

puts "\n--- Задача 3: Влияние шума ---"
signal = generate_signal(freqs_list[2], amps_list[2], t)
[0.5, 1.0, 2.0, 5.0].each do |m|
  noisy = add_noise(signal, m)
  spectrum = compute_fft(noisy)
  peaks = find_peaks(spectrum, fs)
  puts "Шум ×#{m}: частоты #{peaks.join(', ')} Гц"
end
