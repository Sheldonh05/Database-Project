import sqlite3
from faker import Faker

# Create SQLite database and connect to it
conn = sqlite3.connect('business_simulation.db')
cursor = conn.cursor()

# Initialize Faker for generating fake data
fake = Faker()

# Create tables
cursor.execute('''
    CREATE TABLE IF NOT EXISTS Product (
        product_id INTEGER PRIMARY KEY,
        product_name TEXT NOT NULL,
        color TEXT NOT NULL,
        product_type TEXT NOT NULL,
        cost_id INTEGER NOT NULL,
        FOREIGN KEY (cost_id) REFERENCES Cost(cost_id)
    )
''')

cursor.execute('''
    CREATE TABLE IF NOT EXISTS Cost (
        cost_id INTEGER PRIMARY KEY,
        design_id INTEGER,
        FOREIGN KEY (design_id) REFERENCES ProductDesign(design_id)
    )
''')

cursor.execute('''
    CREATE TABLE IF NOT EXISTS ProductDesign (
        design_id INTEGER PRIMARY KEY NOT NULL,
        product_id INTEGER NOT NULL,
        design_name TEXT NOT NULL,
        price REAL NOT NULL,
        FOREIGN KEY (product_id) REFERENCES Product(product_id)

    )
''')

# inventory
cursor.execute('''
    CREATE TABLE IF NOT EXISTS Inventory (
        inventory_id INTEGER PRIMARY KEY,
        product_name TEXT,
        quantity INTEGER,
        location TEXT,
        date_added DATE,
        FOREIGN KEY (product_name) REFERENCES Product(product_name)
    )
''')

# Add the "Driver" table
cursor.execute('''
    CREATE TABLE IF NOT EXISTS Driver (
        driver_id INTEGER PRIMARY KEY,
        driver_name TEXT,
        license_number TEXT,
        date_of_birth DATE,
        contact_number TEXT,
        address TEXT
    )
''')

# Add the "Employee" table with additional attributes
cursor.execute('''
    CREATE TABLE IF NOT EXISTS Employee (
        employee_id INTEGER PRIMARY KEY,
        employee_name TEXT,
        gender TEXT,
        date_of_birth DATE,
        contact_number TEXT,
        address TEXT,
        date_of_joining DATE
    )
''')

cursor.execute('''
    CREATE TABLE IF NOT EXISTS Orders (
        order_id INTEGER PRIMARY KEY,
        order_status TEXT,
        total_price REAL,
        order_dates DATE,
        order_location TEXT,
        customer_id INTEGER,
        FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
    )
''')

cursor.execute('''
    CREATE TABLE IF NOT EXISTS Customer (
        customer_id INTEGER PRIMARY KEY,
        first_name TEXT,
        last_name TEXT,
        email_address TEXT NOT NULL,
        phone_number TEXT,
        address TEXT,
        demographics_id TEXT,
        FOREIGN KEY (demographics_id) REFERENCES Demographics(demographics_id)
    )
''')

cursor.execute('''
    CREATE TABLE IF NOT EXISTS Demographics (
        demographics_id TEXT PRIMARY KEY,
        race TEXT,
        gender INTEGER,
        age INTEGER NOT NULL,
        location TEXT
    )
''')

cursor.execute('''
    CREATE TABLE IF NOT EXISTS Feedback (
        feedback_id TEXT PRIMARY KEY,
        product_id INTEGER,
        feedback_type TEXT,
        date DATE NOT NULL,
        demographics_id TEXT,
        FOREIGN KEY (demographics_id) REFERENCES Demographics(demographics_id)
    )
''')

cursor.execute('''
    CREATE TABLE IF NOT EXISTS Marketing (
        marketing_id INTEGER PRIMARY KEY,
        campaign_type TEXT,
        campaign_name TEXT,
        marketing_type TEXT NOT NULL
    )
''')

cursor.execute('''
    CREATE TABLE IF NOT EXISTS Production_Cost (
        production_cost_id INTEGER PRIMARY KEY,
        component_name TEXT,
        quantity INTEGER,
        cost_per_unit INTEGER
    )
''')
numProducts = 5
numOrders = 50
numCustomers = 10

# Generate synthetic data for the "Driver" table
for _ in range(10):
    cursor.execute('''
        INSERT INTO Driver (
            driver_name,
            license_number,
            date_of_birth,
            contact_number,
            address
        ) VALUES (?, ?, ?, ?, ?)
    ''', (
        fake.name(),
        fake.unique.random_number(9),
        fake.date_of_birth(minimum_age=20, maximum_age=60),
        fake.phone_number(),
        fake.address()
    ))

# Generate synthetic data for the "Employee" table
for _ in range(10):
    cursor.execute('''
        INSERT INTO Employee (
            employee_name,
            gender,
            date_of_birth,
            contact_number,
            address,
            date_of_joining
        ) VALUES (?, ?, ?, ?, ?, ?)
    ''', (
        fake.name(),
        fake.random_element(elements=('Male', 'Female', 'Other')),
        fake.date_of_birth(minimum_age=20, maximum_age=60),
        fake.phone_number(),
        fake.address(),
        fake.date_between(start_date='-5y', end_date='today')
    ))
# product
for _ in range(10):
    cursor.execute('''
        INSERT INTO Product (
            product_id,
            product_name,
            product_type,
            color,
            cost_id
        ) VALUES (?, ?, ?, ?, ?)
    ''', (
        fake.unique.random_number(9),
        fake.random_element(elements=('Iphone', 'MacBook', 'Ipad','Accessories')),
        fake.random_element(elements=('Iphone pro','MacBook pro','Ipad mini','headphone','charger')),
        fake.random_element(elements=('Black', 'White', 'Grey', 'Red', 'Teal')),
        fake.unique.random_number(9)
    ))

# feedback
for _ in range(10):
    cursor.execute('''
        INSERT INTO Feedback (
            feedback_id,
            product_id,
            feedback_type,
            date,
            demographics_id
        ) VALUES (?, ?, ?, ?, ?)
    ''', (
        fake.unique.random_number(9),
        fake.unique.random_number(9),
        fake.random_element(elements=('good', 'bad', 'neutral')),
        fake.date_between(start_date='-5y', end_date='today'),
        fake.unique.random_number(9)
    ))

##### cost
for _ in range(10):
    cursor.execute('''
        INSERT INTO Cost (
            cost_id,
            design_id
        ) VALUES (?, ?)
    ''', (
        fake.unique.random_number(9),
        fake.unique.random_number(9),
    ))

##### Productdesign
for _ in range(10):
    cursor.execute('''
        INSERT INTO ProductDesign (
            design_id,
            product_id,
            design_name,
            price
        ) VALUES (?, ?, ?, ?)
    ''', (
        fake.unique.random_number(9),
        fake.unique.random_number(9),
        fake.random_element(elements=('pro', 'air', 'SE','pro max')),
        fake.random_digit()
    ))



##### Demographics

for _ in range(10):
    cursor.execute('''
        INSERT INTO Demographics (
            demographics_id,
            race,
            gender,
            age,
            location
        ) VALUES (?, ?, ?, ?, ?)
    ''', (
        fake.unique.random_number(9),
        fake.random_element(elements=('Black', 'White', 'Hispanic', 'Asian', 'Other')),
        fake.unique.random_number(3),
        fake.date_of_birth(minimum_age=20, maximum_age=60),
        fake.address()
    ))

##### Inventory
for _ in range(10):
    cursor.execute('''
        INSERT INTO Inventory (
            inventory_id,
            product_name,
            quantity,
            location,
            date_added
        ) VALUES (?, ?, ?, ?, ?)
    ''', (
        fake.unique.random_number(9),
        fake.random_element(elements=('Iphone', 'MacBook', 'Ipad', 'Accessories')),
        fake.unique.random_number(9),
        fake.address(),
        fake.date_between(start_date='-5y', end_date='today')
    ))


##### Order

for _ in range(10):
    cursor.execute('''
        INSERT INTO Orders (
            order_id,
            order_status,
            total_price,
            order_dates,
            order_location,
            customer_id
        ) VALUES (?, ?, ?, ?, ?, ?)
    ''', (
        fake.unique.random_number(9),
        fake.random_element(elements=('No order', 'Pending', 'Completed', 'Returned')),
        fake.random_digit(),
        fake.date_between(start_date='-5y', end_date='today'),
        fake.address(),
        fake.unique.random_number(9)
    ))


##### Customer
for _ in range(10):
    cursor.execute('''
        INSERT INTO Customer (
            customer_id,
            first_name,
            last_name,
            email_address,
            phone_number,
            address,
            demographics_id
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', (
        fake.unique.random_number(9),
        fake.first_name(),
        fake.last_name(),
        fake.safe_email(),
        fake.phone_number(),
        fake.address(),
        fake.unique.random_number(9)
    ))


for _ in range(10):
    cursor.execute('''
        INSERT INTO Marketing (
            marketing_id,
            campaign_type,
            campaign_name,
            marketing_type
        ) VALUES (?, ?, ?, ?)
    ''', (
        fake.unique.random_number(9),
        fake.random_element(elements=('Social Media', 'TV Ads', 'Public', 'Brand')),
        fake.random_element(elements=('Apple', 'Pro', 'Air')),
        fake.random_element(elements=('Content', 'Direct', 'Email'))
    ))

for _ in range(10):
    cursor.execute('''
        INSERT INTO Production_cost (
            production_cost_id,
            component_name,
            quantity,
            cost_per_unit
        ) VALUES (?, ?, ?, ?)
    ''', (
        fake.unique.random_number(9),
        fake.random_element(elements=('Screen', 'Battery', 'Frames', 'Camera')),
        fake.unique.random_number(9),
        fake.random_digit()
    ))

# Commit the changes
conn.commit()

# Close the connection
conn.close()

print("Data is created!")

