-- Enable Row Level Security (RLS)
ALTER TABLE tables ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Users table policies (WITH CHECK allows user creation on signup)
CREATE POLICY "Users can be created" ON users
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can view their own data" ON users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own data" ON users
    FOR UPDATE USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

CREATE POLICY "Admins can view all users" ON users
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Mesas policies (public read access for QR scanning)
CREATE POLICY "Anyone can view active tables" ON tables
    FOR SELECT USING (active = true);

CREATE POLICY "Authenticated users can manage tables" ON tables
    FOR ALL USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);

-- Categorias policies (public read access)
CREATE POLICY "Anyone can view active categories" ON categories
    FOR SELECT USING (active = true);

CREATE POLICY "Authenticated users can manage categories" ON categories
    FOR ALL USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);

-- Itens_cardapio policies (public read access)
CREATE POLICY "Anyone can view available menu items" ON menu_items
    FOR SELECT USING (available = true);

CREATE POLICY "Authenticated users can manage menu items" ON menu_items
    FOR ALL USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);

-- Pedidos policies (public insert for orders, authenticated for management)
CREATE POLICY "Anyone can create orders" ON orders
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can view orders" ON orders
    FOR SELECT USING (true);

CREATE POLICY "Authenticated users can manage orders" ON orders
    FOR ALL USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);

-- Itens_pedido policies (public insert for order items)
CREATE POLICY "Anyone can create order items" ON order_items
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can view order items" ON order_items
    FOR SELECT USING (true);

CREATE POLICY "Authenticated users can manage order items" ON order_items
    FOR ALL USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);

-- Pagamentos policies (public insert for payments)
CREATE POLICY "Anyone can create payments" ON payments
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can view payments" ON payments
    FOR SELECT USING (true);

CREATE POLICY "Authenticated users can manage payments" ON payments
    FOR ALL USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);