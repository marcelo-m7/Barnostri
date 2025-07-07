-- Enable Row Level Security (RLS)
ALTER TABLE mesas ENABLE ROW LEVEL SECURITY;
ALTER TABLE categorias ENABLE ROW LEVEL SECURITY;
ALTER TABLE itens_cardapio ENABLE ROW LEVEL SECURITY;
ALTER TABLE pedidos ENABLE ROW LEVEL SECURITY;
ALTER TABLE itens_pedido ENABLE ROW LEVEL SECURITY;
ALTER TABLE pagamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios ENABLE ROW LEVEL SECURITY;

-- Users table policies (WITH CHECK allows user creation on signup)
CREATE POLICY "Users can be created" ON usuarios
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Users can view their own data" ON usuarios
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own data" ON usuarios
    FOR UPDATE USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

CREATE POLICY "Admins can view all users" ON usuarios
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM usuarios 
            WHERE id = auth.uid() AND tipo = 'admin'
        )
    );

-- Mesas policies (public read access for QR scanning)
CREATE POLICY "Anyone can view active tables" ON mesas
    FOR SELECT USING (ativo = true);

CREATE POLICY "Authenticated users can manage tables" ON mesas
    FOR ALL USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);

-- Categorias policies (public read access)
CREATE POLICY "Anyone can view active categories" ON categorias
    FOR SELECT USING (ativo = true);

CREATE POLICY "Authenticated users can manage categories" ON categorias
    FOR ALL USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);

-- Itens_cardapio policies (public read access)
CREATE POLICY "Anyone can view available menu items" ON itens_cardapio
    FOR SELECT USING (disponivel = true);

CREATE POLICY "Authenticated users can manage menu items" ON itens_cardapio
    FOR ALL USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);

-- Pedidos policies (public insert for orders, authenticated for management)
CREATE POLICY "Anyone can create orders" ON pedidos
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can view orders" ON pedidos
    FOR SELECT USING (true);

CREATE POLICY "Authenticated users can manage orders" ON pedidos
    FOR ALL USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);

-- Itens_pedido policies (public insert for order items)
CREATE POLICY "Anyone can create order items" ON itens_pedido
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can view order items" ON itens_pedido
    FOR SELECT USING (true);

CREATE POLICY "Authenticated users can manage order items" ON itens_pedido
    FOR ALL USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);

-- Pagamentos policies (public insert for payments)
CREATE POLICY "Anyone can create payments" ON pagamentos
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can view payments" ON pagamentos
    FOR SELECT USING (true);

CREATE POLICY "Authenticated users can manage payments" ON pagamentos
    FOR ALL USING (auth.uid() IS NOT NULL) WITH CHECK (auth.uid() IS NOT NULL);