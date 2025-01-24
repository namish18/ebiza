const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql2');

const app = express();
const port = 3000;

// Middleware to parse incoming JSON data
app.use(bodyParser.json());

// MySQL Connection Setup
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'root123',//user password
    database: 'ebiza'//database name
});

db.connect((err) => {
    if (err) {
        console.error('Error connecting to database:', err.message);
    } else {
        console.log('Connected to the database.');
    }
});



app.get('/users', (req, res) => {
    db.query('SELECT * FROM users', (err, results) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.json(results);
        }
    });
});

//login Route
app.post('/login', (req, res) => {
    const { username, password } = req.body;

    const query = 'SELECT * FROM users WHERE fname = ?';
    db.query(query, [username], (err, results) => {
        if (err) {
            return res.status(500).json({ message: 'Database error' });
        }
        if (results.length > 0) {
            const user = results[0];
            const uid = user.uid; // Extract the UID from the database record
            
            if (user.password === password) {  // Ideally, hash passwords in production
                res.status(200).json({
                    message: 'Login successful',
                    redirect: true,
                    uid: uid, // Return the UID in the response
                });
            } else {
                res.status(401).json({ message: 'Incorrect password' });
            }
        } else {
            res.status(404).json({ message: 'User not found' });
        }
    });
});

// Signup Route
app.post('/signup', (req, res) => {
    const { first_name, last_name, email, password, image } = req.body;

    if (!first_name || !last_name || !email || !password) {
        return res.status(400).send("All fields are required.");
    }

    // Default profile image if not provided
    const profileImage = image || 'https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_1280.png' ;

    const query = 'INSERT INTO users (fname, lname, email, password, image_url) VALUES (?, ?, ?, ?, ?)';
    db.query(query, [first_name, last_name, email, password, profileImage], (err, results) => {
        if (err) {
            console.error('Error inserting data:', err.message);
            res.status(500).send('Error inserting data');
        } else {
            res.status(200).send('User signed up successfully!');
        }
    });
});

// GET Endpoint to fetch logged-in user's data
app.get('/get-user', (req, res) => {
    const { uid } = req.query; // Assuming uid is sent as a query parameter

    if (!uid) {
        return res.status(400).json({ error: 'User ID is required.' });
    }

    const query = 'SELECT uid, fname, lname, email, image_url FROM users WHERE uid = ?';

    db.query(query, [uid], (err, results) => {
        if (err) {
            console.error('Error fetching user data:', err);
            return res.status(500).json({ error: 'Failed to fetch user data.' });
        }

        if (results.length === 0) {
            return res.status(404).json({ message: 'User not found.' });
        }

        // Return the user's data
        res.status(200).json({
            message: 'User data fetched successfully!',
            user: results[0],
        });
    });
});


//view all products
app.get('/view-products', (req, res) => {
    const sql = 'SELECT * FROM product';
    db.query(sql, (err, results) => {
        if (err) {
            res.status(500).send('Error fetching products');
        } else {
            res.json(results);
        }
    });
});

app.post('/add-donation', (req, res) => {
    const { uid, amount, fid, words, time } = req.body;

    // Basic validation check
    if (!uid || !amount || !fid || !time) {
        return res.status(400).json({ error: 'All fields except words are required.' });
    }

    // SQL Query to insert a donation
    const insertDonationQuery = `
        INSERT INTO donation (uid, amount, fid, words, time) 
        VALUES (?, ?, ?, ?, ?);
    `;

    // SQL Query to update the 'raised' amount in fundraiser table
    const updateRaisedAmountQuery = `
        UPDATE fundraiser 
        SET raised = raised + ? 
        WHERE fid = ?;
    `;

    // Execute the donation insertion query first
    db.query(insertDonationQuery, [uid, amount, fid, words || null, time], (err, result) => {
        if (err) {
            console.error('Error inserting donation:', err);
            return res.status(500).json({ error: 'Failed to insert donation' });
        }

        const donationId = result.insertId;

        // Update the fundraiser's raised amount
        db.query(updateRaisedAmountQuery, [amount, fid], (err, updateResult) => {
            if (err) {
                console.error('Error updating fundraiser:', err);
                return res.status(500).json({ error: 'Failed to update fundraiser' });
            }

            // Successfully added the donation and updated the fundraiser amount
            res.status(201).json({
                message: 'Donation added successfully and fundraiser amount updated!',
                donationId: donationId
            });
        });
    });
});



// POST Endpoint to add a fundraiser
app.post("/add-fundraiser", (req, res) => {
    const {
      title,
      currency,
      amount,
      raised,
      description,
      story,
      duration,
      duration_mode,
      upi_id,
      image,
      doc,
    } = req.body;
  
    // Validation (optional)
    if (!title || !currency || !amount || !duration || !duration_mode || !upi_id) {
      return res.status(400).json({ error: "Missing required fields" });
    }
  
    // SQL query to insert a new fundraiser
    const sql = `
      INSERT INTO fundraiser 
      (title, currency, amount, raised, description,  duration, duration_mode, upi_id, image_url, document_url)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,  ?)
    `;
  
    // Values array for prepared statement
    const values = [
      title,
      currency,
      amount,
      raised || 0, // Default to 0 if not provided
      description,
      duration,
      duration_mode,
      upi_id,
      image || null,
      doc || null,
    ];
  
    // Execute query
    db.query(sql, values, (err, result) => {
      if (err) {
        console.error("Error inserting fundraiser:", err);
        return res.status(500).json({ error: "Database error" });
      }
      res.status(201).json({ message: "Fundraiser added successfully", fid: result.insertId });
    });
  });
  

// GET Endpoint to view all fundraisers
app.get('/view-fundraiser', (req, res) => {
    const query = 'SELECT * FROM fundraiser';

    db.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching data:', err);
            return res.status(500).json({ error: 'Failed to fetch fundraiser details' });
        }
        res.status(200).json(results);
    });
});
 

// GET Endpoint to view all donations for a specific fundraiser
app.get('/view-donation/:fid', (req, res) => {
    const fundraiserId = req.params.fid;
    const query = `
        SELECT d.did, d.uid, d.amount, d.time, d.words, u.fname AS user_name
        FROM donation d
        JOIN users u ON d.uid = u.uid
        WHERE d.fid = ?;
    `;

    // Execute the query
    db.query(query, [fundraiserId], (err, results) => {
        if (err) {
            console.error('Error fetching donations:', err);
            return res.status(500).json({ error: 'Failed to fetch donations' });
        }

        // If no donations are found for the fundraiser
        if (results.length === 0) {
            return res.status(404).json({ message: 'No donations found for this fundraiser' });
        }

        // Return the list of donations
        res.status(200).json({
            message: 'Donations fetched successfully!',
            donations: results
        });
    });
});

app.get('/user-donation', (req, res) => {
    const { uid } = req.query;
    const query = `
        SELECT d.did, d.uid, d.amount, d.time, d.words, f.name 
        FROM donation d
        JOIN fundraiser_name f ON d.fid = f.fid
        WHERE d.uid = ?;
    `;

    // Execute the query
    db.query(query, [fundraiserId], (err, results) => {
        if (err) {
            console.error('Error fetching donations:', err);
            return res.status(500).json({ error: 'Failed to fetch donations' });
        }

        // If no donations are found for the fundraiser
        if (results.length === 0) {
            return res.status(404).json({ message: 'No donations found for this fundraiser' });
        }

        // Return the list of donations
        res.status(200).json({
            message: 'Donations fetched successfully!',
            donations: results
        });
    });
});



// ✅ ADD item to cart
app.post('/add-to-cart', (req, res) => {
    const { uid, pid, quantity } = req.body;

    if (!uid || !pid || !quantity) {
        return res.status(400).json({ error: 'User ID, Product ID, and Quantity are required.' });
    }

    // Fetch product price
    const getProductPriceQuery = `SELECT price FROM product WHERE pid = ?`;
    db.query(getProductPriceQuery, [pid], (err, result) => {
        if (err || result.length === 0) {
            return res.status(500).json({ error: 'Product not found' });
        }

        const price = result[0].price;
        const total = price * quantity;

        // Insert into cart or update quantity if already exists
        const insertCartQuery = `
            INSERT INTO cart (uid, pid, quantity, total)
            VALUES (?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE 
            quantity = quantity + VALUES(quantity), 
            total = total + VALUES(total);
        `;

        db.query(insertCartQuery, [uid, pid, quantity, total], (err, result) => {
            if (err) {
                return res.status(500).json({ error: 'Failed to add product to cart' ,err});
            }
            res.status(201).json({ message: 'Product added to cart successfully' });
        });
    });
});

// ✅ DELETE item from cart
app.delete('/delete-from-cart', (req, res) => {
    const { cartid } = req.body;

    if (!cartid) {
        return res.status(400).json({ error: 'Cart ID is required.' });
    }

    const deleteQuery = `DELETE FROM cart WHERE cartid = ?`;
    db.query(deleteQuery, [cartid], (err, result) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to delete product from cart' });
        }
        res.status(200).json({ message: 'Product removed from cart successfully' });
    });
});

// ✅ UPDATE quantity in cart
app.put('/update-cart', (req, res) => {
    const { cartid, quantity } = req.body;

    if (!cartid || !quantity) {
        return res.status(400).json({ error: 'Cart ID and Quantity are required.' });
    }

    const updateCartQuery = `
        UPDATE cart 
        JOIN product ON cart.pid = product.pid
        SET cart.quantity = ?, cart.total = product.price * ?
        WHERE cart.cartid = ?;
    `;

    db.query(updateCartQuery, [quantity, quantity, cartid], (err, result) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to update cart quantity' });
        }
        res.status(200).json({ message: 'Cart quantity updated successfully' });
    });
});

// ✅ VIEW cart items
app.get('/view-cart', (req, res) => {
    const { uid } = req.query;
    if (!uid) {
        return res.status(400).json({ error: 'User ID is required.' });
    }

    const viewCartQuery = `
        SELECT cart.cartid, cart.uid, product.name, cart.quantity, cart.total,product.image_url 
        FROM cart cart
        JOIN product product ON cart.pid = product.pid
        WHERE cart.uid = ?;
    `;

    db.query(viewCartQuery, [uid], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err });
        }
        res.status(200).json({ cartItems: result });
    });
});

app.put('/increase-quantity', (req, res) => {
    const { cartid } = req.body;

    if (!cartid) {
        return res.status(400).json({ error: 'Cart ID is required.' });
    }

    const increaseQuantityQuery = `
        UPDATE cart
        JOIN product ON cart.pid = product.pid
        SET cart.quantity = cart.quantity + 1,
            cart.total = (cart.quantity + 1) * product.price
        WHERE cart.cartid = ?;
    `;

    db.query(increaseQuantityQuery, [cartid], (err, result) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to increase quantity.' });
        }
        res.status(200).json({ message: 'Quantity increased successfully.' });
    });
});

// Endpoint to decrease quantity by 1
app.put('/decrease-quantity', (req, res) => {
    const { cartid } = req.body;

    if (!cartid) {
        return res.status(400).json({ error: 'Cart ID is required.' });
    }

    const decreaseQuantityQuery = `
        UPDATE cart
        JOIN product ON cart.pid = product.pid
        SET cart.quantity = cart.quantity - 1,
            cart.total = (cart.quantity - 1) * product.price
        WHERE cart.cartid = ? AND cart.quantity > 1;
    `;

    db.query(decreaseQuantityQuery, [cartid], (err, result) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to decrease quantity.' });
        }
        if (result.affectedRows === 0) {
            return res.status(400).json({ error: 'Cannot decrease quantity below 1.' });
        }
        res.status(200).json({ message: 'Quantity decreased successfully.' });
    });
});


app.post('/add-premium', (req, res) => {
    const { uid, duration } = req.body;

    // Basic validation check
    if (!uid || !duration) {
        return res.status(400).json({ error: 'User ID and duration are required.' });
    }

    // Check for valid duration input
    const validDurations = ['Monthly', 'Quarterly', 'Annually'];
    if (!validDurations.includes(duration)) {
        return res.status(400).json({ error: 'Invalid duration type.' });
    }

    // SQL queries: Insert into premium_plan and update category
    const insertPremiumQuery = `INSERT INTO premium_plan (uid, duration) VALUES (?, ?);`;
    const updateCategoryQuery = `UPDATE users SET category = TRUE WHERE uid = ?;`;

    // Start the transaction to ensure data consistency
    db.beginTransaction((err) => {
        if (err) return res.status(500).json({ error: 'Transaction error.' });

        // Insert into premium_plan
        db.query(insertPremiumQuery, [uid, duration], (err, result) => {
            if (err) {
                return db.rollback(() => {
                    res.status(500).json({ error: 'Failed to add premium plan.' });
                });
            }

            // Update user category
            db.query(updateCategoryQuery, [uid], (err, result) => {
                if (err) {
                    return db.rollback(() => {
                        res.status(500).json({ error: 'Failed to update user category.' });
                    });
                }

                // Commit transaction if both operations succeed
                db.commit((err) => {
                    if (err) {
                        return db.rollback(() => {
                            res.status(500).json({ error: 'Transaction commit error.' });
                        });
                    }
                    res.status(201).json({ message: 'Premium plan added and user category updated successfully!' });
                });
            });
        });
    });
});

//add business
app.post('/add-business', (req, res) => {
    const {
        title,
        description,
        currency,
        amount,
        ask,
        equity,
        contact,
        image_url,
        upi_id,
        document_url,
    } = req.body;

    // Validate input fields
    if (!title || !description || !currency || !amount || !equity || !contact || !upi_id || !image_url || !document_url) {
        return res.status(400).json({ error: 'All fields are required.' });
    }

    // SQL query to insert business data
    const query = `
        INSERT INTO business (
            title,
            description,
            currency,
            amount,
            
            equity,
            contact,
            upi_id,
            image_url,
            
            document_url
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    // Execute query
    db.execute(
        query,
        [
            title,
            description,
            currency,
            amount,
            
            equity,
            contact,
            upi_id,
            image_url,
            
            document_url,
        ],
        (err, results) => {
            if (err) {
                console.error('Error inserting business:', err);
                return res.status(500).json({ error: 'Database error occurred.' });
            }
            res.status(201).json({ message: 'Business added successfully!', bid: results.insertId });
        }
    );
});


//view-business
app.get('/view-business', (req, res) => {
    const query = 'SELECT * FROM business';

    db.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching data:', err);
            return res.status(500).json({ error: 'Failed to fetch business details' });
        }
        res.status(200).json(results);
    });
});

//view-merchandise
app.get('/view-merchandise', (req, res) => {
    const query = 'SELECT * FROM merchandise';

    db.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching data:', err);
            return res.status(500).json({ error: 'Failed to fetch merchandise details' });
        }
        res.status(200).json(results);
    });
});


//update-user
app.post('/update-user', (req, res) => {
    const { uid, fname, lname, email, imageUrl } = req.body;

    if (!uid || !email || !fname) {
        return res.status(400).json({ message: 'UID, email, and first name are required' });
    }

    const updateQuery = `
        UPDATE users
        SET fname = ?, lname = ?, email = ?, image_url = ?
        WHERE uid = ?
    `;

    db.query(
        updateQuery,
        [fname, lname || null, email, imageUrl || null, uid],
        (err, result) => {
            if (err) {
                console.error('Error updating user:', err);
                return res.status(500).json({ message: 'Error updating user', error: err });
            }

            res.json({
                message: 'User updated successfully',
                user: { uid, fname, lname, email, imageUrl }
            });
        }
    );
});



app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});

