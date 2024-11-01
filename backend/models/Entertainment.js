const mongoose = require('mongoose');
const typeList = ['Movie', 'Series'];
const genresList = ['Action', 'Adventure', 'Animation', 'Biography', 'Comedy', 'Crime', 'Drama', 
    'Fantasy', 'History', 'Horror', 'Musical', 'Romance', 'Sci-Fi', 'Sport', 'Thriller', 'War'];
const ratingList = ['G', 'PG', 'PG-13', 'R', 'NC-17', 'TV-Y', 'TV-Y7', 'TV-Y7 FV', 'TV-G', 
    'TV-PG', 'TV-14', 'TV-MA'];
const streamingList = ['Apple TV', 'Crunchyroll', 'HBO GO', 'Hotstar', 'Netflix', 'Prime Video', 'Viu'];

const entertainmentSchema = new mongoose.Schema({
    type: { type: String, required: true, enum: typeList },
    title: { type: String, required: true, unique: true },
    synopsis: String,
    genres: [{ type: String, enum: genresList }],
    rating: { type: String, enum: ratingList },
    score: String,
    duration: String,
    releaseDate: String,
    cast: [{ name: String, photo: String, _id: false }],
    directors: [{ name: String, photo: String, _id: false }],
    productionCos: [String],
    originalLanguage: String,
    streaming: [{ type: String, enum: streamingList }],
    poster: String,
    reviews: [{ name: String, review: String, stars: String, _id: false }]
});

module.exports = mongoose.model('Entertainment', entertainmentSchema, 'Entertainment');