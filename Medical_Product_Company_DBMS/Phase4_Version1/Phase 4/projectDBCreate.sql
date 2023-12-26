Create Table F23_S003_T7_Compounding (
    c_location        varchar2(15) not null,
    compoundingID   varchar2(10) not null,
    product_Name    varchar2(15) not null,
    concentration   char(5),
    storage_temp    char(5),
    primary key(compoundingID)

);

Create Table F23_S003_T7_Sales_Marketing (
    sales_productID     varchar2(10) not null,
    marketing_technique varchar2(25),
    primary key(sales_productID)
);

Create Table F23_S003_T7_Manufacturing (
    MFG_Price       varchar2(5) not null,
    m_location        varchar2(15) not null,
    productID       varchar2(10) not null,
    quantity_of_output  varchar2(10) not null,
    no_of_delays    varchar2(10),
    sales_prodID    varchar2(10) not null,
    box_size        varchar2(5) not null,
    box_color       varchar2(30) not null,
    primary key(productID),
    foreign key(sales_prodID)
        references F23_S003_T7_Sales_Marketing(sales_productID)
        on delete cascade

);

Create Table F23_S003_T7_To_Be_Packaged (
    compoundingID   varchar2(10) not null, 
    productID       varchar2(10) not null,
    p_date            varchar2(10) not null,
    order_qty       varchar2(10) not null,
    primary key(compoundingID, productID),
    foreign key(compoundingID)
        references F23_S003_T7_Compounding(compoundingID)
        on delete cascade,
    foreign key(productID)
        references F23_S003_T7_Manufacturing(productID)
        on delete cascade
);

Create Table F23_S003_T7_Retail (
    retailer_name       varchar2(50) not null,
    r_location            varchar2(20) not null,
    sales_price         varchar2(10) not null,
    num_sold            varchar2(15),
    productID           varchar2(10) not null,
    retailerID          varchar2(10) not null,
    primary key(retailerID),
    foreign key(productID)
        references F23_S003_T7_Manufacturing(productID)
        on delete cascade
);

Create Table F23_S003_T7_Customer (
    c_name        varchar2(25) not null,
    DOB         varchar2(15) not null,
    customerID  varchar2(15) not null,
    primary key(customerID)
);

Create Table F23_S003_T7_Buys (
    b_date        varchar2(10) not null,
    retailerID  varchar2(10) not null,
    customerID  varchar2(15) not null,
    primary key(retailerID, customerID),
    foreign key(retailerID)
        references F23_S003_T7_Retail(retailerID)
        on delete cascade,
    foreign key(customerID)
        references F23_S003_T7_Customer(customerID)
        on delete cascade
);

Create Table F23_S003_T7_Shipped (
    order_qty       varchar2(20) not null,
    retailerID      varchar2(20) not null,
    productID       varchar2(20) not null,
    s_date            varchar2(20) not null,
    primary key(retailerID, productID),
    foreign key(retailerID)
        references F23_S003_T7_Retail(retailerID)
        on delete cascade,
    foreign key(productID)
        references F23_S003_T7_Manufacturing(productID)
        on delete cascade
);

Create Table F23_S003_T7_Feedback (
    rating          varchar2(5),
    customerID      varchar2(15) not null,
    sales_prodID    varchar2(10) not null,
    primary key(customerID, sales_prodID),
    foreign key(customerID)
        references F23_S003_T7_Customer(customerID)
        on delete cascade,
    foreign key(sales_prodID)
        references F23_S003_T7_Sales_Marketing(sales_productID)
        on delete cascade
);