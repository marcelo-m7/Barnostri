-- Helper function to insert users to auth.users
CREATE OR REPLACE FUNCTION insert_user_to_auth(
    email text,
    password text
) RETURNS UUID AS $$
DECLARE
  user_id uuid;
  encrypted_pw text;
BEGIN
  user_id := gen_random_uuid();
  encrypted_pw := crypt(password, gen_salt('bf'));
  
  INSERT INTO auth.users
    (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, recovery_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, email_change, email_change_token_new, recovery_token)
  VALUES
    (gen_random_uuid(), user_id, 'authenticated', 'authenticated', email, encrypted_pw, '2023-05-03 19:41:43.585805+00', '2023-04-22 13:10:03.275387+00', '2023-04-22 13:10:31.458239+00', '{"provider":"email","providers":["email"]}', '{}', '2023-05-03 19:41:43.580424+00', '2023-05-03 19:41:43.585948+00', '', '', '', '');
  
  INSERT INTO auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
  VALUES
    (gen_random_uuid(), user_id, format('{"sub":"%s","email":"%s"}', user_id::text, email)::jsonb, 'email', '2023-05-03 19:41:43.582456+00', '2023-05-03 19:41:43.582497+00', '2023-05-03 19:41:43.582497+00');
  
  RETURN user_id;
END;
$$ LANGUAGE plpgsql;

-- Insert admin user
WITH admin_user AS (
  SELECT insert_user_to_auth('admin@barnostri.com', 'admin123') as user_id
)
INSERT INTO usuarios (id, nome, email, tipo)
SELECT user_id, 'Administrador', 'admin@barnostri.com', 'admin' FROM admin_user;

-- Insert funcionario user
WITH funcionario_user AS (
  SELECT insert_user_to_auth('funcionario@barnostri.com', 'func123') as user_id
)
INSERT INTO usuarios (id, nome, email, tipo)
SELECT user_id, 'Funcionário', 'funcionario@barnostri.com', 'funcionario' FROM funcionario_user;

-- Insert sample tables (mesas)
INSERT INTO mesas (numero, qr_token, ativo) VALUES
('1', 'mesa_001_qr', true),
('2', 'mesa_002_qr', true),
('3', 'mesa_003_qr', true),
('4', 'mesa_004_qr', true),
('5', 'mesa_005_qr', true),
('6', 'mesa_006_qr', true),
('7', 'mesa_007_qr', true),
('8', 'mesa_008_qr', true),
('Balcão', 'balcao_qr', true),
('Deck', 'deck_qr', true);

-- Insert sample categories
INSERT INTO categorias (nome, ordem, ativo) VALUES
('Entradas', 1, true),
('Bebidas', 2, true),
('Pratos Principais', 3, true),
('Sobremesas', 4, true),
('Especiais da Casa', 5, true);

-- Insert sample menu items
INSERT INTO itens_cardapio (nome, descricao, preco, categoria_id, disponivel, imagem_url) VALUES
-- Entradas
('Pastéis de Camarão', 'Deliciosos pastéis recheados com camarão fresco, servidos com molho especial', 18.90, 
 (SELECT id FROM categorias WHERE nome = 'Entradas'), true, null),
('Bolinho de Bacalhau', 'Bolinhos crocantes de bacalhau com batata, temperados com ervas finas', 16.50, 
 (SELECT id FROM categorias WHERE nome = 'Entradas'), true, null),
('Casquinha de Siri', 'Siri refogado com temperos especiais, servido na própria casca', 22.90, 
 (SELECT id FROM categorias WHERE nome = 'Entradas'), true, null),
('Petiscos Variados', 'Seleção de petiscos: azeitona, queijo, presunto e torradinhas', 24.90, 
 (SELECT id FROM categorias WHERE nome = 'Entradas'), true, null),

-- Bebidas
('Caipirinha', 'Caipirinha tradicional com cachaça, limão e açúcar', 12.00, 
 (SELECT id FROM categorias WHERE nome = 'Bebidas'), true, null),
('Caipiroska', 'Caipiroska de vodka com frutas variadas', 14.00, 
 (SELECT id FROM categorias WHERE nome = 'Bebidas'), true, null),
('Cerveja Gelada', 'Cerveja long neck gelada', 8.00, 
 (SELECT id FROM categorias WHERE nome = 'Bebidas'), true, null),
('Água de Coco', 'Água de coco natural gelada', 6.00, 
 (SELECT id FROM categorias WHERE nome = 'Bebidas'), true, null),
('Refrigerante', 'Refrigerante lata 350ml', 5.00, 
 (SELECT id FROM categorias WHERE nome = 'Bebidas'), true, null),
('Suco Natural', 'Suco de frutas naturais: laranja, maracujá, acerola', 8.50, 
 (SELECT id FROM categorias WHERE nome = 'Bebidas'), true, null),

-- Pratos Principais
('Moqueca de Peixe', 'Moqueca tradicional com peixe fresco, dendê e leite de coco', 45.90, 
 (SELECT id FROM categorias WHERE nome = 'Pratos Principais'), true, null),
('Filé de Peixe Grelhado', 'Filé de peixe grelhado com legumes e arroz', 38.90, 
 (SELECT id FROM categorias WHERE nome = 'Pratos Principais'), true, null),
('Camarão na Moranga', 'Camarão refogado servido na moranga com catupiry', 52.90, 
 (SELECT id FROM categorias WHERE nome = 'Pratos Principais'), true, null),
('Picanha na Chapa', 'Picanha grelhada na chapa com farofa e vinagrete', 48.90, 
 (SELECT id FROM categorias WHERE nome = 'Pratos Principais'), true, null),
('Hambúrguer Artesanal', 'Hambúrguer artesanal com batata frita', 28.90, 
 (SELECT id FROM categorias WHERE nome = 'Pratos Principais'), true, null),

-- Sobremesas
('Pudim de Leite', 'Pudim caseiro com calda de caramelo', 12.90, 
 (SELECT id FROM categorias WHERE nome = 'Sobremesas'), true, null),
('Brigadeiro Gourmet', 'Brigadeiro gourmet com granulado especial', 8.90, 
 (SELECT id FROM categorias WHERE nome = 'Sobremesas'), true, null),
('Sorvete', 'Sorvete de creme com frutas', 10.90, 
 (SELECT id FROM categorias WHERE nome = 'Sobremesas'), true, null),
('Mousse de Maracujá', 'Mousse cremoso de maracujá com cobertura', 11.90, 
 (SELECT id FROM categorias WHERE nome = 'Sobremesas'), true, null),

-- Especiais da Casa
('Combo Casal', 'Moqueca + 2 Caipirinhas + Sobremesa para compartilhar', 85.90, 
 (SELECT id FROM categorias WHERE nome = 'Especiais da Casa'), true, null),
('Porção Família', 'Porção grande de camarão + batata frita + vinagrete', 78.90, 
 (SELECT id FROM categorias WHERE nome = 'Especiais da Casa'), true, null),
('Happy Hour', 'Combo petiscos + 4 cervejas geladas', 65.90, 
 (SELECT id FROM categorias WHERE nome = 'Especiais da Casa'), true, null);

-- Insert sample orders
INSERT INTO pedidos (mesa_id, status, total, forma_pagamento, pago) VALUES
((SELECT id FROM mesas WHERE numero = '1'), 'Em preparo', 67.80, 'Pix', false),
((SELECT id FROM mesas WHERE numero = '2'), 'Pronto', 45.90, 'Cartão', true),
((SELECT id FROM mesas WHERE numero = '3'), 'Recebido', 32.50, 'Dinheiro', false);

-- Insert sample order items
INSERT INTO itens_pedido (pedido_id, item_cardapio_id, quantidade, observacao, preco_unitario) VALUES
-- Pedido 1
((SELECT id FROM pedidos WHERE total = 67.80), 
 (SELECT id FROM itens_cardapio WHERE nome = 'Moqueca de Peixe'), 1, 'Menos pimenta', 45.90),
((SELECT id FROM pedidos WHERE total = 67.80), 
 (SELECT id FROM itens_cardapio WHERE nome = 'Caipirinha'), 2, '', 12.00),

-- Pedido 2
((SELECT id FROM pedidos WHERE total = 45.90), 
 (SELECT id FROM itens_cardapio WHERE nome = 'Moqueca de Peixe'), 1, '', 45.90),

-- Pedido 3
((SELECT id FROM pedidos WHERE total = 32.50), 
 (SELECT id FROM itens_cardapio WHERE nome = 'Pastéis de Camarão'), 1, '', 18.90),
((SELECT id FROM pedidos WHERE total = 32.50), 
 (SELECT id FROM itens_cardapio WHERE nome = 'Cerveja Gelada'), 1, '', 8.00),
((SELECT id FROM pedidos WHERE total = 32.50), 
 (SELECT id FROM itens_cardapio WHERE nome = 'Água de Coco'), 1, '', 6.00);

-- Insert sample payments
INSERT INTO pagamentos (pedido_id, metodo, valor, status, transacao_id) VALUES
((SELECT id FROM pedidos WHERE total = 45.90), 'Cartão', 45.90, 'Aprovado', 'TXN_001'),
((SELECT id FROM pedidos WHERE total = 67.80), 'Pix', 67.80, 'Pendente', 'PIX_002'),
((SELECT id FROM pedidos WHERE total = 32.50), 'Dinheiro', 32.50, 'Pendente', null);