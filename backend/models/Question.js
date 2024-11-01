const mongoose = require('mongoose');
const keyword = ['Movie', 'Series', 'Action', 'Adventure', 'Animation', 'Biography', 'Comedy', 'Crime', 'Drama', 'Fantasy',
    'History', 'Horror', 'Musical', 'Romance', 'Sci-Fi', 'Sport', 'Thriller', 'War', 'G', 'PG', 'PG-13', 'R', 'NC-17', 'TV-Y', 'TV-Y7', 'TV-Y7 FV', 'TV-G', 'TV-PG', 'TV-14', 'TV-MA', 'Apple TV', 'Crunchyroll', 'HBO GO', 'Hotstar', 'Netflix', 'Prime Video', 'Viu'];

const questionSchema = new mongoose.Schema({
    question: { type: String, required: true },
    options: {
        type: Map,
        of: { type: [String], enum: keyword },
        required: true
    },
});

module.exports = mongoose.model('Question', questionSchema, 'Questions');
