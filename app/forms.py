from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, BooleanField, SubmitField
from wtforms.validators import DataRequired


# ===============   WEB APP   ===============
class AuthForm(FlaskForm):
    username = StringField('Tell me who you are:', validators=[DataRequired()])
    account_address = StringField(
        'Account address:', validators=[DataRequired()])
    contract_address = StringField(
        'Contract address:', validators=[DataRequired()])
    submit = SubmitField('Sign In')


class ChangeAddrForm(FlaskForm):
    contract_address = StringField(
        'New contract address:', validators=[DataRequired()])
    submit = SubmitField('Change')


# ===============   REQUESTS   ==============
class NewHomeRequest(FlaskForm):
    home_address = StringField('Home address:', validators=[DataRequired()])
    home_area = StringField('Home area:', validators=[DataRequired()])
    home_cost = StringField('Home cost:', validators=[DataRequired()])
    submit = SubmitField('OK')


class EditHomeRequest(FlaskForm):
    home_address = StringField('Home address:', validators=[DataRequired()])
    home_area = StringField('Home area:', validators=[DataRequired()])
    home_cost = StringField('Home cost:', validators=[DataRequired()])
    submit = SubmitField('OK')


class AddOwnerRequest(FlaskForm):
    owner = StringField('IDK', validators=[DataRequired()])
    submit = SubmitField('OK')


class ProcessRequest(FlaskForm):
    request_id = StringField('Request ID:', validators=[DataRequired()])
    submit = SubmitField('Process')


# ===============   METHODS   ===============
class AddHome(FlaskForm):
    home_address = StringField('Home address:', validators=[DataRequired()])
    home_area = StringField('Home area:', validators=[DataRequired()])
    home_cost = StringField('Home cost:', validators=[DataRequired()])
    submit = SubmitField('Add')


class GetHome(FlaskForm):
    home_address = StringField('Home address:', validators=[DataRequired()])
    submit = SubmitField('Get')


class AddEmployee(FlaskForm):
    empl_addr = StringField('Employee\'s account address:',
                            validators=[DataRequired()])
    name = StringField('Employee\'s name:', validators=[DataRequired()])
    position = StringField('Employee\'s position:',
                           validators=[DataRequired()])
    phone_number = StringField(
        'Employee\'s phone number:', validators=[DataRequired()])
    submit = SubmitField('Add')


class GetEmployee(FlaskForm):
    empl_addr = StringField('Employee\'s account address:',
                            validators=[DataRequired()])
    submit = SubmitField('Get')


class EditEmployee(FlaskForm):
    empl_addr = StringField('Employee\'s account address:',
                            validators=[DataRequired()])
    name = StringField('Employee\'s name:', validators=[DataRequired()])
    position = StringField('Employee\'s position:',
                           validators=[DataRequired()])
    phone_number = StringField(
        'Employee\'s phone number:', validators=[DataRequired()])
    submit = SubmitField('Edit')


class DeleteEmployee(FlaskForm):
    empl_addr = StringField('Employee\'s account address:',
                            validators=[DataRequired()])
    submit = SubmitField('Delete')
