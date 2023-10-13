// import 'package:bloc/bloc.dart';
//
// import '../local/db.dart';
// import '../model/product_model.dart';
//
// // Events
// abstract class ProductEvent {}
//
// class LoadProducts extends ProductEvent {}
//
// class AddProduct extends ProductEvent {
//   final Product product;
//
//   AddProduct(this.product);
// }
//
// class UpdateProduct extends ProductEvent {
//   final Product product;
//
//   UpdateProduct(this.product);
// }
//
// class DeleteProduct extends ProductEvent {
//   final String barcode;
//
//   DeleteProduct(this.barcode);
// }
//
// // States
// abstract class ProductState {}
//
// class ProductInitial extends ProductState {}
//
// class ProductsLoaded extends ProductState {
//   final List<Product> products;
//
//   ProductsLoaded(this.products);
// }
//
// class ProductError extends ProductState {
//   final String error;
//
//   ProductError(this.error);
// }
//
// // BLoC
// class ProductBloc extends Bloc<ProductEvent, ProductState> {
//   final ProductDatabase _productDatabase = ProductDatabase();
//
//   ProductBloc() : super(ProductInitial());
//
//   @override
//   Stream<ProductState> mapEventToState(ProductEvent event) async* {
//     if (event is LoadProducts) {
//       try {
//         final products = await _productDatabase.getAllProducts();
//         yield ProductsLoaded(products);
//       } catch (e) {
//         yield ProductError('Failed to load products: $e');
//       }
//     } else if (event is AddProduct) {
//       try {
//         await _productDatabase.insertProduct(event.product);
//         final products = await _productDatabase.getAllProducts();
//         yield ProductsLoaded(products);
//       } catch (e) {
//         yield ProductError('Failed to add product: $e');
//       }
//     } else if (event is UpdateProduct) {
//       try {
//         await _productDatabase.updateProduct(event.product);
//         final products = await _productDatabase.getAllProducts();
//         yield ProductsLoaded(products);
//       } catch (e) {
//         yield ProductError('Failed to update product: $e');
//       }
//     } else if (event is DeleteProduct) {
//       try {
//         await _productDatabase.deleteProduct(event.barcode);
//         final products = await _productDatabase.getAllProducts();
//         yield ProductsLoaded(products);
//       } catch (e) {
//         yield ProductError('Failed to delete product: $e');
//       }
//     }
//   }
// }
