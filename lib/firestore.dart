// final docRef = db
//     .collection("cities")
//     .withConverter(
//       fromFirestore: City.fromFirestore,
//       toFirestore: (City city, options) => city.toFirestore(),
//     )
//     .doc("LA");
// // await docRef.set(city);