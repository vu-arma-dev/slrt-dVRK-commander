function Rnorm=renormalize(Rin)
q=rot2quat(Rin);
Rnorm=quat2rot(q);
end