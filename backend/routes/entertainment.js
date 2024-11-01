const express = require('express');
const router = express.Router();
const Entertainment = require('../models/Entertainment');

// GET all data
router.get('/', async (req, res) => {
    try {
        const entertainment = await Entertainment.find();
        res.status(200).json(entertainment);
    } catch (err) {
        res.status(500).send('Internal Server Error');
    }
});

// GET 
router.get('/:id', async (req, res) => {
    try {
        const entertainment = await Entertainment.findById(req.params.id);
        if (!entertainment) return res.status(404).send('Not found');
        res.status(200).json(entertainment);
    } catch (err) {
        res.status(500).send('Internal Server Error');
    }
});

// POST 
router.post('/', async (req, res) => {
    try {
        if (Array.isArray(req.body)) {
            const entertainment = await Entertainment.insertMany(req.body);
            res.status(201).json(entertainment);
        } else {
            const entertainment = new Entertainment(req.body);
            await entertainment.save();
            res.status(201).json(entertainment);
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

router.post('/:id', async (req, res) => {
    try {
        const updated = await Entertainment.findByIdAndUpdate(
            req.params.id,
            { $push: req.body }, 
            { new: true, useFindAndModify: false } 
        );
        if (!updated) return res.status(404).send('Not found');
        res.status(200).json(updated);
    } catch (err) {
        res.status(500).send('Internal Server Error');
    }
});

// PUT (update)
router.put('/:id', async (req, res) => {
    try {
        const updated = await Entertainment.findByIdAndUpdate(
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
        const updated = await Entertainment.findByIdAndUpdate(
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
        const deleted = await Entertainment.findByIdAndDelete(req.params.id);
        if (!deleted) return res.status(404).send('Not found');
        res.status(200).send('Deleted');
    } catch (err) {
        res.status(500).send('Internal Server Error');
    }
});

module.exports = router;
