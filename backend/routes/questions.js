const express = require('express');
const router = express.Router();
const Question = require('../models/Question');

// GET all data
router.get('/', async (req, res) => {
    try {
        const questions = await Question.find();
        res.status(200).json(questions);
    } catch (err) {
        res.status(500).send('Internal Server Error');
    }
});

// GET 
router.get('/:id', async (req, res) => {
    try {
        const question = await Question.findById(req.params.id);
        if (!question) return res.status(404).send('Not found');
        res.status(200).json(question);
    } catch (err) {
        res.status(500).send('Internal Server Error');
    }
});

// POST 
router.post('/', async (req, res) => {
    try {
        if (Array.isArray(req.body)) {
            const questions = await Question.insertMany(req.body);
            res.status(201).json(questions);
        } else {
            const question = new Question(req.body);
            await question.save();
            res.status(201).json(question);
        }
    } catch (err) {
        console.error('Error:', err);
        if (err.code === 11000) {
            res.status(400).json({ message: 'The information already exists', error: err });
        }
        else if (err.name === 'ValidationError') {
            res.status(400).json({ message: 'Validation Error', errors: err.errors });
        }
        else {
            res.status(500).json({ message: 'Internal Server Error', error: err });
        }
    }
});


// PUT (update)
router.put('/:id', async (req, res) => {
    try {
        const updated = await Question.findByIdAndUpdate(
            req.params.id,
            req.body,
            { new: true }
        );
        if (!updated) return res.status(404).send('Not found');
        res.status(200).json(updated);
    } catch (err) {
        res.status(500).send('Internal Server Error');
    }
});

// PATCH
router.patch('/:id', async (req, res) => {
    try {
        const updated = await Question.findByIdAndUpdate(
            req.params.id,
            req.body,
            { new: true }
        );
        if (!updated) return res.status(404).send('Not found');
        res.status(200).json(updated);
    } catch (err) {
        res.status(500).send('Internal Server Error');
    }
});

// DELETE
router.delete('/:id', async (req, res) => {
    try {
        const deleted = await Question.findByIdAndDelete(req.params.id);
        if (!deleted) return res.status(404).send('Not found');
        res.status(200).send('Deleted');
    } catch (err) {
        res.status(500).send('Internal Server Error');
    }
});

module.exports = router;
