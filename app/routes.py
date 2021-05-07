from flask import render_template, flash, redirect, url_for, session
from app import app
from app.forms import AuthForm, ChangeAddrForm
from app.forms import AddEmployee, GetEmployee, EditEmployee, DeleteEmployee, AddHome, GetHome
from app.forms import NewHomeRequest, EditHomeRequest, AddOwnerRequest, ProcessRequest
from app.blockchain import Blockchain


bb = None


# ===============   WEB APP   ===============
@app.route('/')
@app.route('/index')
def index():
    if 'logged' in session:
        user = {'nickname': session.get('username')}
        info = [
            {
                'key': 'Account address',
                'body': session.get('account_adr')
            },
            {
                'key': 'Contract address',
                'body': session.get('contract_adr')
            },
            {
                'key': 'Balance',
                'body': bb.getBalance()
            }
        ]
        return render_template("index.html",
                               title='Home',
                               addr=session.get('account_adr'),
                               user=user,
                               info=info)
    else:
        return redirect(url_for('auth'))


@app.route('/login', methods=['GET', 'POST'])
def auth():
    if 'logged' in session:
        return redirect(url_for('index'))
    else:
        # session['logged'] = '+'
        # session['username'] = 'baiytaan'
        # session['account_adr'] = '0x0D10b2c2a567CdEE28130AcefEe3Ce4B29A33E66'
        # session['contract_adr'] = '0x2F805DB52496E2925E64B389D04849aE720f66bc' # ~TO CHANGE~
        # global bb
        # bb = Blockchain('0x0D10b2c2a567CdEE28130AcefEe3Ce4B29A33E66',
        #                 '0x1B5aE046431c0Be70e6e473baa382Da712A8B3f7')
        # return redirect(url_for('index'))
        form = AuthForm()
        if form.validate_on_submit():
            session['logged'] = '+'
            session['username'] = form.username.data
            session['account_adr'] = form.account_address.data
            session['contract_adr'] = form.contract_address.data
            global bb
            bb = Blockchain(form.account_address.data,
                            form.contract_address.data)
            return redirect(url_for('index'))
        return render_template('auth.html',  title='Sign In', form=form)


@app.route('/logout')
def session_reset():
    session.clear()
    return redirect(url_for('auth'))


@app.route('/menu')
def menu():
    if 'logged' in session:
        return render_template('menu.html', addr=session.get('account_adr'))
    else:
        return redirect(url_for('auth'))


@app.route('/change_address', methods=['GET', 'POST'])
def change_address():
    if 'logged' in session:
        form = ChangeAddrForm()
        if form.validate_on_submit():
            session.pop('contract_adr', None)
            session['contract_adr'] = form.contract_address.data
            return redirect(url_for('index'))
        return render_template('addr_change.html', form=form)
    else:
        return redirect(url_for('auth'))


# ===============   REQUESTS   ==============
@app.route('/requests/new_home', methods=['GET', 'POST'])
def new_home_request():
    form = NewHomeRequest()
    if form.validate_on_submit():
        x = ' . . . '
        #  . . .
    return render_template('methods.html', addr=session.get('account_adr'), mode='\"New home\" request', form=form)


@app.route('/requests/edit_home', methods=['GET', 'POST'])
def edit_home_request():
    form = EditHomeRequest()
    if form.validate_on_submit():
        x = ' . . . '
        #  . . .
    return render_template('methods.html', addr=session.get('account_adr'), mode='\"Edit home\" request', form=form)


@app.route('/requests/add_owner', methods=['GET', 'POST'])
def add_owner_request():
    form = AddOwnerRequest()
    if form.validate_on_submit():
        x = ' . . . '
        #  . . .
    return render_template('methods.html', addr=session.get('account_adr'), mode='\"Add owner\" request', form=form)


@app.route('/requests/get_list', methods=['GET', 'POST'])
def get_request_list():
    x = ' . . . '
    #  . . .
    return redirect(url_for('index'))


@app.route('/requests/process', methods=['GET', 'POST'])
def process_request():
    form = ProcessRequest()
    if form.validate_on_submit():
        x = ' . . . '
        #  . . .
    return render_template('methods.html', addr=session.get('account_adr'), mode='Process request', form=form)


# ===============   METHODS   ===============
@app.route('/methods/homes/add', methods=['GET', 'POST'])
def add_home():
    form = AddHome()
    if form.validate_on_submit():
        x = ' . . . '
        #  . . .
    return render_template('methods.html', addr=session.get('account_adr'), mode='Add home', form=form)


@app.route('/methods/homes/get', methods=['GET', 'POST'])
def get_home():
    form = GetHome()
    if form.validate_on_submit():
        x = ' . . . '
        #  . . .
    return render_template('methods.html', addr=session.get('account_adr'), mode='Get home', form=form)


@app.route('/methods/homes/get_list', methods=['GET', 'POST'])
def get_home_list():
    x = ' . . . '
    #  . . .
    return redirect(url_for('index'))


@app.route('/methods/ownership/add', methods=['GET', 'POST'])
def add_ownership():
    x = ' . . . '
    #  . . .
    return redirect(url_for('index'))


@app.route('/methods/ownership/get', methods=['GET', 'POST'])
def get_ownership():
    x = ' . . . '
    #  . . .
    return redirect(url_for('index'))


@app.route('/methods/employees/add', methods=['GET', 'POST'])
def add_employee():
    form = AddEmployee()
    if form.validate_on_submit():
        bb.addEmployee(form.empl_addr.data, form.name.data,
                       form.position.data, form.phone_number.data)
    return render_template('methods.html', addr=session.get('account_adr'), mode='Add employee', form=form)


@app.route('/methods/employees/get', methods=['GET', 'POST'])
def get_employee():
    form = GetEmployee()
    if form.validate_on_submit():
        print(bb.getEmployee(form.empl_addr.data))
        #  . . .
    return render_template('methods.html', addr=session.get('account_adr'), mode='Get employee', form=form)


@app.route('/methods/employees/edit', methods=['GET', 'POST'])
def edit_employee():
    form = EditEmployee()
    if form.validate_on_submit():
        x = ' . . . '
        #  . . .
    return render_template('methods.html', addr=session.get('account_adr'), mode='Edit employee', form=form)


@app.route('/methods/employees/delete', methods=['GET', 'POST'])
def delete_employee():
    form = DeleteEmployee()
    if form.validate_on_submit():
        print(bb.deleteEmployee(form.empl_addr.data))
        #  . . .
    return render_template('methods.html', addr=session.get('account_adr'), mode='Delete employee', form=form)


@app.route('/methods/transact/get_price', methods=['GET', 'POST'])
def get_price():
    x = ' . . . '
    #  . . .
    return redirect(url_for('index'))
