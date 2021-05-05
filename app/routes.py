from flask import render_template, flash, redirect, url_for, session
from app import app
from app.forms import AuthForm


@app.route('/')
@app.route('/index')
def index():
    if 'username' in session:
        username = session.get('username')
        user = {'nickname': username}
        posts = [  
            {
                'author': {'nickname': 'Harold'},
                'body': 'What is pain?....'
            },
            {
                'author': {'nickname': 'Pepega'},
                'body': 'Pepegagagagagaga!'
            }
        ]
        return render_template("index.html",
                               title='Home',
                               user=user,
                               posts=posts)
    else:
        return redirect(url_for('auth'))


@app.route('/login', methods=['GET', 'POST'])
def auth():
    form = AuthForm()
    if form.validate_on_submit():
        session['username'] = form.username.data
        return redirect(url_for('index'))
    return render_template('auth.html',  title='Sign In', form=form)

@app.route('/delete-auth-data/')
def delete_visits():
    session.pop('username', None)
    return 'OK.'
