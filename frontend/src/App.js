import logo from './logo.svg';
import './App.css';
import {
  BrowserRouter as Router,
  Switch,
  Route,
} from "react-router-dom";

import Restaurants from './containers/Restaurants';
import Foods from './containers/Foods';
import Orders from './containers/Orders';

function App() {
  return (
    <Router>
      <Switch>
        {/* exactというpropsはデフォルトではfalse
        exactと記述することでpathの完全一致の場合にのみ
        コンポーネントをレンダリングする
        */}
        <Route
        exact
        path="/restaurants"
        >
          < Orders />
        </Route>

        {/* matchとは、routepathがurlにどのようにマッチするのかについての情報を含んでいる。
        具体的には、params, isExact, path, url */}
        <Route
        exact
        path="/restaurants/:restauransId/foods"
        render={({ match }) =>
          <Foods
            match={match}
          />
        }
        />

        <Route
        exact
        path="/orders"
        >
          < Restaurants />
        </Route>
      </Switch>
    </Router>
  );
}

export default App;
