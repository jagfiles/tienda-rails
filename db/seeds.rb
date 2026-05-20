puts "🌱 Creando categorías..."
[
  { name: "Electrónica", description: "Gadgets y dispositivos" },
  { name: "Ropa",        description: "Moda y accesorios" },
  { name: "Hogar",       description: "Artículos para el hogar" },
  { name: "Deportes",    description: "Equipamiento deportivo" },
  { name: "Libros",      description: "Literatura y educación" }
].each { |c| Category.find_or_create_by!(name: c[:name]) { |r| r.description = c[:description] } }

el = Category.find_by!(name: "Electrónica")
ro = Category.find_by!(name: "Ropa")
ho = Category.find_by!(name: "Hogar")
de = Category.find_by!(name: "Deportes")
li = Category.find_by!(name: "Libros")

puts "🌱 Creando productos..."
[
  { name: "Auriculares Bluetooth Pro",  price: 12999.99, stock: 50, category: el, description: "Cancelación de ruido y 30hs de batería." },
  { name: "Smartwatch Fitness",         price: 24999.00, stock: 30, category: el, description: "Monitor cardíaco, GPS y resistencia al agua." },
  { name: "Teclado Mecánico RGB",       price: 8999.50,  stock: 20, category: el, description: "Switches Cherry MX y retroiluminación RGB." },
  { name: "Mouse Gamer 6400DPI",        price: 5499.00,  stock: 45, category: el, description: "Alta precisión para gaming profesional." },
  { name: "Remera Deportiva Dry-Fit",   price: 2499.00,  stock: 100, category: ro, description: "Tela transpirable de secado rápido." },
  { name: "Zapatillas Running Pro",     price: 15999.00, stock: 25, category: ro, description: "Amortiguación avanzada para running." },
  { name: "Mochila Urbana 30L",         price: 7999.00,  stock: 40, category: ro, description: "Resistente al agua con compartimento para laptop." },
  { name: "Cafetera de Cápsulas",       price: 19999.00, stock: 15, category: ho, description: "Compatible con cápsulas Nespresso." },
  { name: "Set Sartenes Antiadherentes",price: 9499.00,  stock: 20, category: ho, description: "Set de 3 sartenes de piedra." },
  { name: "Pelota de Fútbol Pro",       price: 4999.00,  stock: 35, category: de, description: "Cuero sintético talla 5." },
  { name: "Mat de Yoga Premium",        price: 6999.00,  stock: 30, category: de, description: "Antideslizante, 6mm de espesor." },
  { name: "Clean Code",                 price: 3999.00,  stock: 20, category: li, description: "Robert Martin — guía para código limpio." },
  { name: "El Principito",              price: 1499.00,  stock: 50, category: li, description: "Edición especial ilustrada." }
].each do |p|
  Product.find_or_create_by!(name: p[:name]) do |r|
    r.price = p[:price]; r.stock = p[:stock]
    r.category = p[:category]; r.description = p[:description]
    r.active = true
  end
end

puts "🌱 Creando usuarios..."
User.find_or_create_by!(email: "admin@tienda.com") do |u|
  u.password = "password123"; u.password_confirmation = "password123"
  u.first_name = "Admin"; u.last_name = "TiendaRails"; u.role = :admin
end
User.find_or_create_by!(email: "cliente@tienda.com") do |u|
  u.password = "password123"; u.password_confirmation = "password123"
  u.first_name = "Juan"; u.last_name = "García"
  u.phone = "+54 9 11 1234-5678"; u.address = "Av. Corrientes 1234, CABA"
end

puts "✅ Listo!"
puts "👤 Admin:   admin@tienda.com / password123"
puts "👤 Cliente: cliente@tienda.com / password123"