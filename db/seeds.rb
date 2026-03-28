# Admin user — change password before production!
Admin.find_or_create_by!(email: "admin@aiyashi.ru") do |a|
  a.password = "Admin123!"
  a.password_confirmation = "Admin123!"
end
puts "Admin created: admin@aiyashi.ru / Admin123!"

# Services
services_data = [
  {
    name: "Имплантация зубов",
    category: "dentistry",
    price_rub: 45_000,
    position: 0,
    description: "Имплантация зубов по немецким и корейским технологиям в ведущих стоматологических клиниках Харбина. Стоимость в 2–3 раза ниже российских цен при сопоставимом качестве."
  },
  {
    name: "Протезирование и коронки",
    category: "dentistry",
    price_rub: 12_000,
    position: 1,
    description: "Металлокерамические и безметалловые коронки, мосты и съёмные протезы. Быстрое изготовление в собственной зуботехнической лаборатории."
  },
  {
    name: "Лазерная коррекция зрения LASIK",
    category: "ophthalmology",
    price_rub: 85_000,
    position: 2,
    description: "Безболезненная лазерная коррекция зрения с использованием оборудования Bausch+Lomb. Восстановление зрения уже на следующий день после операции."
  },
  {
    name: "Хирургия катаракты",
    category: "ophthalmology",
    price_rub: 90_000,
    position: 3,
    description: "Факоэмульсификация катаракты с имплантацией интраокулярной линзы. Операция занимает 15–20 минут, госпитализация не требуется."
  },
  {
    name: "Эндопротезирование суставов",
    category: "orthopedics",
    price_rub: 350_000,
    position: 4,
    description: "Тотальное эндопротезирование тазобедренного и коленного суставов протезами ведущих производителей. Полная реабилитация под наблюдением китайских специалистов."
  },
  {
    name: "Лечение онкологии",
    category: "oncology",
    price_rub: nil,
    position: 5,
    description: "Химиотерапия, лучевая терапия, таргетная терапия и иммунотерапия в специализированных онкологических центрах. Стоимость рассчитывается индивидуально."
  },
  {
    name: "Пластическая хирургия",
    category: "cosmetic",
    price_rub: 120_000,
    position: 6,
    description: "Ринопластика, блефаропластика, подтяжка лица, коррекция контуров тела. Работа с ведущими пластическими хирургами Китая."
  },
  {
    name: "Комплексный чекап",
    category: "checkup",
    price_rub: 55_000,
    position: 7,
    description: "Полное медицинское обследование организма за 2–3 дня: анализы крови, МРТ, КТ, УЗИ, ЭКГ, консультации специалистов. Идеально для профилактики и раннего выявления заболеваний."
  }
]

services_data.each do |data|
  Service.find_or_create_by!(name: data[:name]) do |s|
    s.category    = data[:category]
    s.price_rub   = data[:price_rub]
    s.description = data[:description]
    s.position    = data[:position]
    s.active      = true
  end
end

puts "Created #{Service.count} services."
