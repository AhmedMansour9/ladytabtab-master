const functions = require("firebase-functions");
const algoliasearch = require("algoliasearch").default;
const admin = require("firebase-admin");

admin.initializeApp();

const ALGOLIA_ADMIN_KEY = "1e0d3f7804cfb19970971441532dc104";
const ALGOLIA_ID = "8W80YE3RSM";
const ALGOLIA_INDEX_NAME = "ladytabtab";
const client = algoliasearch(ALGOLIA_ID, ALGOLIA_ADMIN_KEY);
const index = client.initIndex(ALGOLIA_INDEX_NAME);

exports.onProductCreated = functions.firestore
  .document("Products/{prodUid}")
  .onCreate((snap, context) => {
    const products = snap.data();

    products.objectID = context.params.prodUid;

    return index.saveObject(products);
  });

exports.onProductUpdated = functions.firestore
  .document("Products/{prodUid}")
  .onUpdate((change, context) => {
    // SAVE NEW DATA
    const newData = change.after.data();
    // GET ID AFTER CHANGES
    // const objID = change.after.id;
    newData.objectID = context.params.prodUid;

    return index.saveObject(newData);
  });

exports.onProductDeleted = functions.firestore
  .document("Products/{prodUid}")
  .onDelete((snap) => {
    return index.deleteObject(snap.id);
  });
