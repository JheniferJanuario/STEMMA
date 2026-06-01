namespace STEMMA.Domain.Cadastro.Entities;

public class Veterinario
{
    public Guid Id { get; private set; }

    public string Nome { get; private set; }

    public string CRMV { get; private set; }

    public string Email { get; private set; }
    public string Senha { get; private set; }

    public string Especialidade { get; private set; }

    public DateTime DataCriacao { get; private set; }

    protected Veterinario() { }

    public Veterinario(
        string nome,
        string crmv,
        string email,
        string senha,
        string especialidade)
    {
        Validar(
            nome,
            crmv,
            email,
            senha,
            especialidade);

        Id = Guid.NewGuid();
        Nome = nome;
        CRMV = crmv;
        Email = email;
        Senha = senha;
        Especialidade = especialidade;
        DataCriacao = DateTime.UtcNow;
    }

    public void AlterarNome(string nome, string crmv, string email, string especialidade)
    {
        if (string.IsNullOrWhiteSpace(nome))
            throw new Exception(
                "Nome obrigatório.");
        if (string.IsNullOrWhiteSpace(crmv))
            throw new Exception(
                "CRMV obrigatório.");

        if (string.IsNullOrWhiteSpace(email))
            throw new Exception(
                "Email obrigatório.");

        if (string.IsNullOrWhiteSpace(especialidade))
            throw new Exception(
                "Especialidade obrigatória.");

        Nome = nome;
        CRMV = crmv;
        Email = email;
        Especialidade = especialidade;
    }

    public void AlterarEspecialidade(
        string especialidade)
    {
        if (string.IsNullOrWhiteSpace(especialidade))
            throw new Exception(
                "Especialidade obrigatória.");

        Especialidade = especialidade;
    }

    private void Validar(
        string nome,
        string crmv,
        string email,
        string senha,
        string especialidade)
    {
        if (string.IsNullOrWhiteSpace(nome))
            throw new Exception(
                "Nome obrigatório.");

        if (string.IsNullOrWhiteSpace(crmv))
            throw new Exception(
                "CRMV obrigatório.");

        if (string.IsNullOrWhiteSpace(email))
            throw new Exception(
                "Email obrigatório.");

        if (string.IsNullOrWhiteSpace(senha))
            throw new Exception("Senha obrigatória.");

        if (senha.Length < 6)
            throw new Exception("A senha deve possuir no mínimo 6 caracteres.");

        if (string.IsNullOrWhiteSpace(especialidade))
            throw new Exception(
                "Especialidade obrigatória.");
    }
}