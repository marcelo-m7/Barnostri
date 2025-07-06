const admin = require('firebase-admin');
const { v4: uuidv4 } = require('uuid');

// Inicializa o Firebase Admin SDK
const serviceAccount = require('./serviceAccountKey.json'); // arquivo gerado no Firebase Console

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

async function seed() {
  const restaurantId = uuidv4();
  const restaurantRef = db.collection('restaurants').doc(restaurantId);

  // Dados do restaurante
  await restaurantRef.set({
    name: 'Bar do João',
    logoUrl: 'https://example.com/logo.png',
    description: 'Petiscos e bebidas na beira da praia',
    location: 'Av. Beira Mar, 123',
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    ownerId: 'user_abc123',
    active: true,
  });

  // Mesas
  const tables = [
    { number: 'Mesa 1' },
    { number: 'Mesa 2' },
    { number: 'Mesa 3' },
  ];

  for (const table of tables) {
    const tableRef = restaurantRef.collection('tables').doc();
    await tableRef.set({
      ...table,
      qrCodeUrl: `https://app.com/r/${restaurantId}/mesa/${tableRef.id}`,
      isOccupied: false,
    });
  }

  // Menu
  const menuItems = [
    {
      name: 'Caipirinha',
      description: 'Cachaça, limão, açúcar e gelo',
      price: 15.0,
      category: 'Bebidas',
      imageUrl: 'https://example.com/img/caipirinha.jpg',
      available: true,
    },
    {
      name: 'Bolinho de Bacalhau',
      description: '6 unidades crocantes',
      price: 20.0,
      category: 'Petiscos',
      imageUrl: 'https://example.com/img/bolinho.jpg',
      available: true,
    },
  ];

  for (const item of menuItems) {
    await restaurantRef.collection('menu').add(item);
  }

  // Pedido de exemplo
  const orderRef = await restaurantRef.collection('orders').add({
    userId: 'user_xyz789',
    tableId: 'Mesa 1',
    status: 'pendente',
    pickupType: 'balcao',
    items: [
      {
        itemId: 'item123',
        name: 'Caipirinha',
        quantity: 2,
        unitPrice: 15.0,
        total: 30.0,
      },
    ],
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    notes: 'Com pouco gelo',
  });

  console.log(`📦 Firestore inicializado com restaurante ID: ${restaurantId}`);
}

seed().catch(console.error);
