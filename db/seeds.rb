# Admin user — change password before production!
Admin.find_or_create_by!(email: "admin@aiyashi.ru") do |a|
  a.password = "Admin123!"
  a.password_confirmation = "Admin123!"
end
puts "Admin created: admin@aiyashi.ru / Admin123!"

# Clear existing services (nullify FK in inquiries first)
Inquiry.update_all(service_id: nil)
Service.delete_all
puts "Old services cleared."

services_data = [
  # ─── Терапия ───────────────────────────────────────────────────────────────
  { category: "therapy", position:  0, name: "Анестезия (ледокаин, ультракаин)",
    price_rub: 90 },
  { category: "therapy", position:  1, name: "Лечение среднего кариеса",
    price_rub: 300 },
  { category: "therapy", position:  2, name: "Лечение глубокого кариеса",
    price_rub: 700 },
  { category: "therapy", position:  3, name: "Лечение атипического кариеса",
    price_rub: 145 },
  { category: "therapy", position:  4, name: "Кариес на дополнительной поверхности",
    price_rub: 330 },
  { category: "therapy", position:  5, name: "Установка анкерного штифта",
    price_rub: 300 },
  { category: "therapy", position:  6, name: "Пульпит 1-корневого зуба",
    price_rub: 300 },
  { category: "therapy", position:  7, name: "Пульпит 2-корневого зуба",
    price_rub: 350 },
  { category: "therapy", position:  8, name: "Пульпит 3-корневого зуба",
    price_rub: 500 },
  { category: "therapy", position:  9, name: "Периодонтит однокорневого зуба",
    price_rub: 500 },
  { category: "therapy", position: 10, name: "Периодонтит двухкорневого зуба",
    price_rub: 700 },
  { category: "therapy", position: 11, name: "Периодонтит трёхкорневого зуба",
    price_rub: 900 },
  { category: "therapy", position: 12, name: "Периодонтит дополнительного канала",
    price_rub: 180,
    description: "Доплата за каждый дополнительный канал" },
  { category: "therapy", position: 13, name: "Постановка временной пломбы",
    price_rub: 135 },
  { category: "therapy", position: 14, name: "Закрытие перфорации корня",
    price_rub: 600 },

  # ─── Пародонтология ────────────────────────────────────────────────────────
  { category: "periodontology", position:  0, name: "Ультразвуковое снятие налёта и зубного камня (обе челюсти)",
    price_rub: 450 },
  { category: "periodontology", position:  1, name: "Пескоструйная обработка и шлифовка (обе челюсти)",
    price_rub: 225 },
  { category: "periodontology", position:  2, name: "Нанесение защитного покрытия, фторирование",
    price_rub: 450 },
  { category: "periodontology", position:  3, name: "Медикаментозная обработка пародонтального кармана (1 зуб)",
    price_rub: 45 },
  { category: "periodontology", position:  4, name: "Удаление наддесневых зубных отложений (1 зуб)",
    price_rub: 45 },
  { category: "periodontology", position:  5, name: "Наложение фиксирующей лечебной повязки",
    price_rub: 135 },
  { category: "periodontology", position:  6, name: "Вскрытие пародонтального абсцесса",
    price_rub: 180 },
  { category: "periodontology", position:  7, name: "Гингивопластика, гингивоэктомия (1 зуб)",
    price_rub: 180 },
  { category: "periodontology", position:  8, name: "Коагуляция десны (1 зуб)",
    price_rub: 225 },
  { category: "periodontology", position:  9, name: "Закрытый кюретаж (1 зуб)",
    price_rub: 270 },

  # ─── Ортодонтия ────────────────────────────────────────────────────────────
  { category: "orthodontics", position:  0, name: "Консультация и составление плана ортодонтического лечения",
    price_rub: 0 },
  { category: "orthodontics", position:  1, name: "Лечение несъёмной ортодонтической техникой (один зубной ряд)",
    price_rub: 15_300 },
  { category: "orthodontics", position:  2, name: "Наблюдение пациента с ортодонтическим аппаратом (установлен в клинике)",
    price_rub: 0 },
  { category: "orthodontics", position:  3, name: "Снятие аппаратуры, чистка, шлифовка и полировка (изготовлено в клинике)",
    price_rub: 0 },
  { category: "orthodontics", position:  4, name: "Фиксация несъёмного ретейнера после снятия брекет-системы",
    price_rub: 700 },
  { category: "orthodontics", position:  5, name: "Изготовление съёмного ретейнера после снятия брекет-системы",
    price_rub: 1_200 },

  # ─── Имплантология ─────────────────────────────────────────────────────────
  { category: "implantology", position: 0, name: "Имплантация зуба",
    price_rub: 58_500,
    description: "Установка стоматологического импланта. Стоимость определяется индивидуально в зависимости от клинической ситуации." },

  # ─── Ортопедия (протезирование) ────────────────────────────────────────────
  { category: "prosthodontics", position:  0, name: "Полный съёмный протез акриловый (одна челюсть, гарантия 5 лет)",
    price_rub: 10_000 },
  { category: "prosthodontics", position:  1, name: "Микропротез (1–2 искусственных зуба)",
    price_rub: 1_700 },
  { category: "prosthodontics", position:  2, name: "Микропротез (3–4 искусственных зуба)",
    price_rub: 3_000 },
  { category: "prosthodontics", position:  3, name: "Частичный съёмный протез акриловый с кламерным креплением",
    price_rub: 7_500 },
  { category: "prosthodontics", position:  4, name: "Установка керамических зубов на акриловую основу (1 единица)",
    price_rub: 6_500,
    description: "Стоимость включает: зуб + акриловая основа + полиуретановая основа." },
  { category: "prosthodontics", position:  5, name: "Армирование съёмного протеза титановой сеточкой",
    price_rub: 700 },
  { category: "prosthodontics", position:  6, name: "Съёмный бюгельный протез из полиуретана (одна челюсть, простой)",
    price_rub: 13_500,
    description: "Пластмассовые зубы немецкого производства, кламерное крепление." },
  { category: "prosthodontics", position:  7, name: "Съёмный бюгельный протез из полиуретана (одна челюсть, сложный)",
    price_rub: 12_500,
    description: "Многозвеньевой кламер, несколько кламеров. Пластмассовые зубы немецкого производства." },
  { category: "prosthodontics", position:  8, name: "Бюгельный протез с замковым креплением",
    price_rub: 32_000 },
  { category: "prosthodontics", position:  9, name: "Съёмный протез нейлоновый эластичный",
    price_rub: 14_500 },
  { category: "prosthodontics", position: 10, name: "Коррекция протеза (надстройка)",
    price_rub: 225 },
  { category: "prosthodontics", position: 11, name: "Отливка модели (одна челюсть)",
    price_rub: 180 },
  { category: "prosthodontics", position: 12, name: "Коррекция протеза (пришлифовывание), изготовленного в клинике",
    price_rub: 0 },
  { category: "prosthodontics", position: 13, name: "Моделирование зубов на диагностической модели",
    price_rub: 270 },

  # ─── Зуботехническая лаборатория (металлокерамика) ────────────────────────
  { category: "dental_lab", position:  0, name: "Коронка кобальто-никелевый сплав, китайская масса (гарантия 3 года)",
    price_rub: 1_200 },
  { category: "dental_lab", position:  1, name: "Коронка кобальто-никелевый сплав, японская керамическая масса (гарантия 6 лет)",
    price_rub: 1_500 },
  { category: "dental_lab", position:  2, name: "Коронка титановый сплав, немецкая масса (гарантия 10 лет)",
    price_rub: 2_700 },
  { category: "dental_lab", position:  3, name: "Коронка титановый сплав, корейская масса (гарантия 12 лет)",
    price_rub: 2_900 },
  { category: "dental_lab", position:  4, name: "Коронка кобальто-хромовый, японская керамическая масса (гарантия 15 лет)",
    price_rub: 3_100 },
  { category: "dental_lab", position:  5, name: "Коронка кобальто-хромовый, немецкая масса (гарантия 17 лет)",
    price_rub: 3_600 },
  { category: "dental_lab", position:  6, name: "Коронка кобальто-хромовый, корейская масса (гарантия 20 лет)",
    price_rub: 4_000 },
  { category: "dental_lab", position:  7, name: "Коронка сплав золота, паллад. и платины, немецкая керамическая масса (гарантия 20 лет)",
    price_rub: 4_700 },
  { category: "dental_lab", position:  8, name: "Коронка из диоксида циркония (гарантия 10 лет)",
    price_rub: 6_300 },
  { category: "dental_lab", position:  9, name: "Виниры из диоксида циркония",
    price_rub: 5_850 },
  { category: "dental_lab", position: 10, name: "Временная коронка",
    price_rub: 180 },
  { category: "dental_lab", position: 11, name: "Вкладка литая",
    price_rub: 500 },
  { category: "dental_lab", position: 12, name: "Извлечение анкерного штифта из корневого канала",
    price_rub: 180 },
  { category: "dental_lab", position: 13, name: "Цельнолитая коронка из кобальто-хромового сплава",
    price_rub: 900 },

  # ─── Рентгенография ────────────────────────────────────────────────────────
  { category: "xray", position: 0, name: "Рентгенологическое исследование зубов (до 3 единиц подряд)",
    price_rub: 145 },
  { category: "xray", position: 1, name: "Панорамный снимок зубов (ортопантомограмма)",
    price_rub: 330 }
]

services_data.each do |data|
  Service.create!(
    name:        data[:name],
    category:    data[:category],
    price_rub:   data[:price_rub],
    description: data[:description],
    position:    data[:position],
    active:      true
  )
end

puts "Created #{Service.count} dental services."
