# --- Параметры сигнала ---
sampling_rate = 10_000  # Частота дискретизации
duration = 1.0          # Продолжительность сигнала

# Временные точки от 0 до 0.9999 с шагом 1/10000 (0.0001)
time_steps = (0...sampling_rate).map { |i| i.to_f / sampling_rate }

# --- Определение трёх разных сигналов ---
signal_defs = {
  case1: { freqs: [100], amps: [1] },                # Один синус с частотой 100 Гц и амплитудой 1
  case2: { freqs: [100, 300, 700], amps: [1, 1, 1] }, # Сумма трёх синусов с одинаковыми амплитудами
  case3: { freqs: [100, 300, 700], amps: [3, 2, 1] }  # Те же частоты, но разные амплитуды: 3, 2 и 1
}

# --- Функция для расчёта амплитуд на заданных частотах (разреженное ДПФ) ---
def compute_dft(signal, sampling_rate, target_freqs)
  n = signal.size     # Количество точек в сигнале
  results = {}        # Словарь: частота => амплитуда

  target_freqs.each do |f|  # Проходим по каждой интересующей частоте
    re = 0.0  # Реальная часть (cos)
    im = 0.0  # Мнимая часть (sin)

    signal.each_with_index do |y, i|  # Перебираем точки сигнала
      angle = 2.0 * Math::PI * f * i / sampling_rate  # Угол аргумента
      re += y * Math.cos(angle)
      im -= y * Math.sin(angle)
    end

    amplitude = Math.sqrt(re**2 + im**2) * 2.0 / n
    results[f] = amplitude  # Сохраняем амплитуду для этой частоты
  end

  return results
end

# --- Генерация сигналов, расчёт ДПФ и вывод ---
signal_defs.each do |case_name, defn|
  freqs = defn[:freqs]
  amps  = defn[:amps]

  signal = time_steps.map do |t|
    freqs.each_with_index.sum { |f, idx| amps[idx] * Math.cos(2 * Math::PI * f * t) }
  end

  dft = compute_dft(signal, sampling_rate, freqs)

  puts "\n#{case_name}: Результаты ДПФ:"
  dft.each { |f, a| puts "Частота #{f} Гц → амплитуда #{a.round(3)}" }

  # Считаем коэффициент сжатия
  n = signal.size
  m = freqs.size
  ratio = n.to_f / m
  puts "Коэффициент сжатия: #{n} отсчётов / #{m} значений = ≈ #{ratio.round(1)}"
end

# --- Проверка, как сигнал изменится, если в него добавить шум ---
noise_levels = [0.1, 1.0, 5.0]  # Слабый, средний и сильный шум

signal_defs.each do |case_name, defn|
  freqs = defn[:freqs]
  amps  = defn[:amps]

  base_signal = time_steps.map do |t|
    freqs.each_with_index.sum { |f, idx| amps[idx] * Math.cos(2 * Math::PI * f * t) }
  end

  noise_levels.each do |noise_amp|
    # Добавляем шум: каждое значение плюс случайное число в пределах ±noise_amp
    noisy = base_signal.map { |y| y + (rand * 2 - 1) * noise_amp }

    dft_noisy = compute_dft(noisy, sampling_rate, freqs)

    puts "\n#{case_name} с шумом амплитудой ±#{noise_amp}:"
    dft_noisy.each { |f, a| puts "Частота #{f} Гц → амплитуда #{a.round(3)}" }
  end
end
