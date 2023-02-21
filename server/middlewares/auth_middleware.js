const { tokenKey } = require("../constants");

const jwt = req('jsonwebtoken');
const authMiddleware = async(req, res, next)=>{
    try {
        const token = req.header(tokenKey)
        if(!token){
            return res.status(401).json({msg:"No auth token, access denied"});
        }
        const verfied = jwt.verify(token, 'passwordKey')

        if(!verfied)return res.status(401).json({msg:'Token verfication failed'})
        req.token = token;
        req.userId = verfied.id;
        next(); 
    } catch (error) {
        return res.status(401).json({msg:'Internal Error'})
    }
}